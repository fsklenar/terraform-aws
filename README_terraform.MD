Executing Terraform code in GitLab CI/CD pipelines, especially with GitLab 18 and higher, is a common and highly recommended practice for Infrastructure as Code (IaC). Here's a breakdown of how to achieve this, incorporating best practices:

## Core Concepts

  * **Infrastructure as Code (IaC):** Defining your infrastructure (servers, networks, databases, etc.) in code, allowing it to be version-controlled, reviewed, and deployed consistently.
  * **Terraform:** An open-source IaC tool that allows you to define and provision infrastructure using a declarative configuration language.
  * **GitLab CI/CD:** GitLab's built-in Continuous Integration/Continuous Delivery service that automates the stages of your software development lifecycle, including building, testing, and deploying.
  * **`.gitlab-ci.yml`:** The configuration file in your GitLab repository that defines your CI/CD pipeline.
  * **Terraform State:** A file that maps your Terraform configuration to the real-world infrastructure it manages. It's crucial for Terraform to know what resources exist and how they are configured.
  * **GitLab Managed Terraform State:** GitLab offers a built-in HTTP backend for managing Terraform state, providing versioning and state locking. This is a highly recommended approach.
  * **CI/CD Variables:** Securely store sensitive information (like cloud provider credentials) in GitLab CI/CD variables.

## Steps to Execute Terraform in GitLab Pipeline

### 1\. Project Setup and Terraform Code

  * **GitLab Project:** Create a new GitLab project or use an existing one to store your Terraform configuration files.
  * **Terraform Files:**
      * `main.tf`: Defines your primary Terraform resources.
      * `variables.tf`: Declares input variables for your Terraform configuration.
      * `outputs.tf`: Defines output variables from your configuration.
      * `versions.tf`: Specifies the required Terraform version and provider versions.
      * `providers.tf`: Configures your cloud provider(s) (e.g., AWS, Azure, GCP).
      * **Optional:** `terraform.tfvars` (for local development, but *never* commit sensitive values here; use GitLab CI/CD variables instead).
  * **`.gitignore`:** Crucial for preventing sensitive files (like `.tfstate` and `.tfvars`) from being committed to your repository. A typical `.gitignore` for Terraform includes:
    ```
    # Local .terraform directories
    **/.terraform/*

    # .tfstate files
    *.tfstate
    *.tfstate.*

    # Crash log files
    crash.log
    crash.*.log

    # Exclude all .tfvars files, which are likely to contain sensitive data
    *.tfvars
    *.tfvars.json

    # Ignore override files
    override.tf
    override.tf.json
    *_override.tf
    *_override.tf.json

    # Ignore CLI configuration files
    .terraformrc
    terraform.rc
    ```

### 2\. Configure Terraform Backend (GitLab Managed State)

It's highly recommended to use GitLab's built-in HTTP backend for managing your Terraform state.

In your `main.tf` or `backend.tf` file, configure the backend like this:

```terraform
terraform {
  backend "http" {
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0" # Use an appropriate version
    }
    # Add other providers as needed
  }
}
```

When `terraform init` runs in the GitLab pipeline, it will automatically detect and configure the GitLab HTTP backend using predefined CI/CD variables.

### 3\. Set Up GitLab CI/CD Variables

Sensitive credentials (like AWS `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, or GCP service account JSON) should *never* be hardcoded in your Terraform files or `.gitlab-ci.yml`. Instead, use GitLab CI/CD variables:

  * Navigate to your project in GitLab.
  * Go to **Settings \> CI/CD \> Variables**.
  * Click **Add variable**.
  * Enter the `Key` (e.g., `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `GOOGLE_APPLICATION_CREDENTIALS`).
  * Enter the `Value` (your actual secret).
  * **Important:**
      * Check `Mask variable` to prevent the value from being displayed in job logs.
      * Check `Protected variable` if this variable should only be available to jobs running on protected branches or tags (e.g., `main`, `production`).
      * For `GOOGLE_APPLICATION_CREDENTIALS` (if using GCP), set the `Type` to `File` and paste the JSON content as the value. GitLab will then provide a path to this file as an environment variable.

### 4\. Create `.gitlab-ci.yml`

This file defines your pipeline stages and jobs. A typical Terraform pipeline includes `validate`, `plan`, and `apply` stages. You might also add `fmt` (format) and `destroy`.

```yaml
# .gitlab-ci.yml

image:
  name: "hashicorp/terraform:latest" # Use the official Terraform Docker image
  entrypoint:
    - "/usr/bin/env"
    - "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

variables:
  TF_ROOT: ${CI_PROJECT_DIR} # Assumes Terraform code is at the project root
  TF_CLI_ARGS_plan: "-out=plan.tfplan" # Save plan to a file
  TF_CLI_ARGS_apply: "plan.tfplan" # Use the saved plan for apply

cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - ${TF_ROOT}/.terraform # Cache Terraform plugins for faster runs

stages:
  - validate
  - plan
  - apply
  - destroy # Optional: Add a destroy stage for cleanups (use with caution!)

# Common setup for all Terraform jobs
.terraform_setup: &terraform_setup
  before_script:
    - cd ${TF_ROOT}
    - terraform --version
    - terraform init -backend=true # Initialize backend dynamically

# Validate job
validate:
  stage: validate
  <<: *terraform_setup
  script:
    - terraform validate
    - terraform fmt -check=true # Check for proper formatting
  rules:
    - if: $CI_COMMIT_BRANCH
  allow_failure: true # Allow validate to fail without stopping the pipeline (optional, depends on your team's policy)

# Plan job
plan:
  stage: plan
  <<: *terraform_setup
  script:
    - terraform plan
  artifacts:
    name: plan
    paths:
      - ${TF_ROOT}/plan.tfplan # Save the plan artifact
    reports:
      terraform: ${TF_ROOT}/tfplan.json # Generate JSON plan for MR widgets
  rules:
    - if: $CI_COMMIT_BRANCH
      when: always # Always run plan on branch commits
    - if: $CI_MERGE_REQUEST_IID # Also run on merge requests
      when: always

# Apply job (manual, usually for protected branches)
apply:
  stage: apply
  <<: *terraform_setup
  script:
    - terraform apply $TF_CLI_ARGS_apply
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH # Only run on default branch (e.g., main)
      when: manual # Requires manual approval
  dependencies:
    - plan # Ensure plan runs before apply

# Destroy job (manual and highly restricted)
destroy:
  stage: destroy
  <<: *terraform_setup
  script:
    - terraform destroy -auto-approve
  rules:
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
      when: manual # Very important: requires manual approval
      allow_failure: false # Ensure destroy job completion is strictly tracked
    - if: $CI_PIPELINE_SOURCE == "web" # Allow manual trigger from UI
      when: manual
      allow_failure: false
  needs: [] # Destroy doesn't depend on previous stages for its execution, but can be triggered independently
```

### Explanation of the `.gitlab-ci.yml` components:

  * **`image`**: Specifies the Docker image to use for your jobs. `hashicorp/terraform:latest` is a good starting point. You can also specify a specific version (e.g., `hashicorp/terraform:1.6.5`).
  * **`entrypoint`**: Overrides the default entrypoint of the Docker image to ensure standard shell behavior.
  * **`variables`**:
      * `TF_ROOT`: Defines the path to your Terraform code within the repository.
      * `TF_CLI_ARGS_plan` and `TF_CLI_ARGS_apply`: Used to pass arguments to Terraform commands, ensuring the plan is saved and then applied.
  * **`cache`**: Caches the `.terraform` directory to speed up `terraform init` by reusing downloaded provider plugins.
  * **`stages`**: Defines the order of execution for your jobs: `validate`, `plan`, `apply`, `destroy`.
  * **`.terraform_setup` (anchor)**: A YAML anchor to avoid repetition. It defines `before_script` steps common to all Terraform jobs: navigating to the `TF_ROOT`, checking Terraform version, and initializing Terraform with the backend.
  * **`validate` job**:
      * Runs `terraform validate` to check syntax.
      * Runs `terraform fmt -check=true` to ensure code formatting.
      * `rules`: Defines when the job should run (e.g., on any branch commit).
      * `allow_failure: true`: (Optional) Allows the pipeline to continue even if validation fails. This might be useful for rapid feedback during development, but for production, you'd likely want it to fail.
  * **`plan` job**:
      * Runs `terraform plan -out=plan.tfplan` to generate an execution plan.
      * `artifacts`: Saves the `plan.tfplan` file and generates a `tfplan.json` report. The `tfplan.json` is particularly useful for GitLab's Terraform integration, showing plan details in merge requests.
      * `rules`: Runs on every branch commit and merge request.
  * **`apply` job**:
      * Runs `terraform apply plan.tfplan` to apply the changes defined in the plan.
      * `rules`: **Crucially**, set `when: manual` and restrict it to your default/protected branch (`$CI_DEFAULT_BRANCH`). This ensures that infrastructure changes require a manual approval step, preventing accidental deployments to production.
      * `dependencies: - plan`: Ensures this job only runs after the `plan` job has successfully completed and its artifact is available.
  * **`destroy` job**:
      * Runs `terraform destroy -auto-approve` to tear down the infrastructure.
      * **Extremely important:** Set `when: manual` and restrict it heavily (e.g., only on protected branches, or only triggerable by specific users/roles). This is a destructive operation and should be used with extreme caution and explicit approval. `allow_failure: false` is also important here.

## Best Practices and Considerations

  * **Version Control Everything:** Treat your Terraform code like application code. Use Git branches, merge requests, and code reviews.
  * **Environment-Specific Configurations:** For multiple environments (dev, staging, prod), use separate Terraform workspaces or, more commonly, separate directories/modules and potentially separate GitLab projects or branches, often with different `tfvars` files or variable groups in GitLab.
      * You can set up `rules` in your `.gitlab-ci.yml` to trigger specific jobs based on which folder or branch is modified.
  * **Terraform State Management:**
      * **GitLab Managed State:** As shown above, this is the easiest and most integrated approach within GitLab. It provides state locking, versioning, and access control.
      * **Dedicated Remote Backend:** For more complex scenarios or if you prefer a cloud-native solution, you can use S3 (AWS), Azure Blob Storage, or GCS (Google Cloud Storage) for your Terraform state, with proper access control and encryption.
  * **Security:**
      * **CI/CD Variables:** Always use masked and protected CI/CD variables for sensitive data.
      * **Least Privilege:** Ensure the credentials used by your GitLab Runner (e.g., IAM role for AWS, Service Principal for Azure) have only the minimum necessary permissions to manage the infrastructure.
      * **Infrastructure as Code (IaC) Scanning:** Integrate security scanning tools like Checkov, Tfsec, or KICS into your `validate` or a dedicated `security_scan` stage to identify potential security vulnerabilities or policy violations in your Terraform code *before* deployment. GitLab Ultimate offers built-in IaC scanning.
  * **Review and Approval Workflows:**
      * **Manual Apply:** Always configure the `apply` job to be manual, especially for production environments. This creates an explicit gate for human review and approval.
      * **Merge Request Integration:** GitLab automatically integrates Terraform plan output into merge requests (if you output `tfplan.json`), providing a clear summary of changes before merging.
  * **Idempotency:** Terraform is inherently idempotent. Running `terraform apply` multiple times with the same configuration should result in the same infrastructure state.
  * **Rollbacks:** While Terraform can manage changes, direct rollbacks via `terraform rollback` are not standard. Instead, rely on Git history: revert to a previous commit in your Terraform code and run the pipeline again.
  * **Terraform Modules:** Promote reusability by creating and using Terraform modules for common infrastructure patterns. You can even host your private Terraform modules in GitLab's built-in Module Registry.

By following these guidelines, you can build a robust, secure, and automated Terraform deployment pipeline within GitLab CI/CD, regardless of the GitLab version (as the core principles remain consistent with GitLab 18 and higher).