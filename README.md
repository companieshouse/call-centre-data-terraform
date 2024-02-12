# call-centre-data-terraform

Infrastructure code for the provisioning of object storage for call centre data (logs, emails).

## Overview

An S3 bucket is provisioned for the storage of call centre data, along with an IAM 'accessor' user with suitable policy and credentials, which is intended for use with client applications such as [WinSCP](https://winscp.net/eng/index.php) and [Cyberduck](https://cyberduck.io/) for managing objects in this bucket.

An additionaal IAM 'migrator' user can be created by setting the boolean variable `data_migration_enabled` to `true` on a per-environment basis. This user is allowed to assume a role which permits the retrieval of S3 objects from an external source bucket (specified by the `data_migration_source_bucket_arn` variable) and upload of objects to the call centre data bucket, and is intended for the migration of data between an external S3 bucket and the call centre data bucket.

Data is encrypted at rest using [server-side encryption](https://docs.aws.amazon.com/AmazonS3/latest/userguide/UsingServerSideEncryption.html) with Amazon S3 managed encryption keys (SSE-S3). Server-side encryption with AWS Key Management Service (AWS KMS) keys (SSE-KMS) or customer-provided keys (SSE-C) is explicitly blocked via an S3 bucket policy—by denying `PutObject` requests with the `aws:kms` header—to ensure that objects in the S3 bucket use the same server-side encryption method (i.e. SSE-S3).

## Branching Strategy

This project uses a trunk-based branching strategy and infrastructure changes are versioned and applied from the `main` branch after merge via the [infrastructure pipeline](https://github.com/companieshouse/ci-pipelines/blob/master/pipelines/ssplatform/team-platform/call-centre-data-terraform):

```mermaid
%%{init: { 'logLevel': 'debug', 'theme': 'default' , 'themeVariables': {
    'git0': '#4585ed',
    'git1': '#edad45'
} } }%%
gitGraph
commit
branch feature
commit
commit
commit
checkout main
merge feature tag: "1.0.0"
```
## License

This project is subject to the terms of the [MIT License](/LICENSE).
