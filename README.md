# Welcome

This codebase is a sample solution from the book [Mastering Terraform](https://amzn.to/3XNjHhx). This codebase is the solution from Chapter 7 where Soze Enterprises is deploying their solution using AWS EC2. It includes infrastructure as code (IaC) using Terraform and configuration management with Packer. Here is a summary of the key components:

## Packer Code

The Packer code is stored in `src\packer` under directories for each of the two Packer templates. One for the `frontend` and another for the `backend`. These Packer templates ultimately deploy the code stored in `src\dotnet`.

## Terraform Code

The Terraform code is stored in `src\terraform`. There is only one root module and it resides within this directory. There is only the default input variables value file `terraform.tfvars` that is loaded by default.

After you build Virtual Machine Images with Packer you will need to update the input variables `frontend_image_name` and `backend_image_name` to reference the correct version.

You may need to change the `primary_region` input variable value if you wish to deploy to a different region. The default is `us-west-2`.

If you want to provision more than one environment you may need to remove the `environment_name` input variable value and specify an additional environment `tfvar` file.

## GitHub Actions Workflows

### Packer Workflows
There are two GitHub Actions workflows that use Packer to build the Virtual Machine images.

### Terraform Workflows
The directory `.github/workflows/` contains GitHub Actions workflows that implement a CI/CD solution using Packer and Terraform. There are individual workflows for the three Terraform core workflow operations `plan`, `apply`, and `destroy`.

# Pre-Requisites

## AWS IAM Setup

In order for GitHub Actions workflows to execute you need to have an identity that they can use to access AWS. Therefore you need to setup a new User in AWS IAM for both the Terraform and Packer workflows. In addition, for each App Registration you should create a Client Secret to be used to authenticate.

The IAM User's Access and Secret Keys need to be set as Environment Variables in GitHub. They should be stored in a GitHub environment Variable `AWS_ACCESS_KEY_ID` and it's client Secret stored in `AWS_SECRET_ACCESS_KEY`.

## AWS Setup

### IAM User Role Assignments

The IAM User created in the previous step needs to be granted `Administrator` access to your AWS Account.

### Change Packer Target Region

Both of the Packer configuration directories for the `backend` and `frontend` container a file called `variables.pkrvars.hcl`. This file contains configuration values that are passed into Packer by the GitHub Actions. Both the Packer templates contain an input variable `aws_primary_region` that allows you to change the AWS Region that the Packer images are stored upon successful completion then you should update the value for `aws_primary_region`. The default is `us-west-2`.

### S3 Bucket for Terraform State

Lastly you need to setup an S3 Bucket that can be used to store Terraform State. You need to create an S3 Bucket called `terraformer0000`. Replace the four (4) zeros (i.e., `0000`) with a four (4) digit random number.

### GitHub Configuration

You need to add the following environment variables:

- AWS_ACCESS_KEY_ID
- BUCKET_NAME
- BUCKET_REGION

You need to add the following secrets:

- AWS_SECRET_ACCESS_KEY
- SSH_PUBLIC_KEY