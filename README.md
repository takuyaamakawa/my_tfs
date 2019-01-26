This repository is for my terraform in OCI environment.

Before using this terraform configurtion, I need to setup terraform and configure common configuration such as env-vars, variables.tf, provider.tf

Below is the tree for this terraform environment.

```
├── env
│   └── env-vars
└── my_tfs
    ├── README.md
    ├── common
    │   ├── provider.tf
    │   └── variables.tf
    ├── db_systems
    │   ├── README.md
    │   ├── datasources.tf
    │   ├── outputs.tf
    │   ├── provider.tf -> ../common/provider.tf
    │   ├── remote-exec.tf
    │   ├── resources.tf
    │   ├── scripts
    │   │   └── bootstrap.sh
    │   ├── terraform.tfstate
    │   ├── terraform.tfstate.backup
    │   └── variables.tf -> ../common/variables.tf
    └── vcn
        ├── provider.tf -> ../common/provider.tf
        ├── terraform.tfstate
        ├── terraform.tfstate.backup
        ├── variables.tf -> ../common/variables.tf
        └── vcn_full.tf
```

** Basic policy 

when I create the new configuration, create directory under my_tfs.
After that, move current directory to the created directory and execute command below.
"ln -s ../common/* ."

** before execute terraform command

. ../env/env-vars


