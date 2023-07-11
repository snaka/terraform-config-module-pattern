# Terraform Environment-Specific Configuration with Modules

This repository demonstrates an approach for managing environment-specific configurations in Terraform using modules. By separating common configurations from environment-specific ones and modularizing them, you can enhance reusability and maintainability of your configurations.

## Approach Overview

Follow these steps to implement the pattern of loading environment-specific configurations with modules:

1. Define the common configurations in the `config.yml` file.
2. Specify environment-specific configurations in separate `environments/{env-name}/config.yml` files (where `{env-name}` represents the environment name).
3. Organize shared modules under the `modules/{module-name}` directory.
4. Create a module under `modules/conf/` that reads the environment-specific configurations.
   - This module merges the common configurations with the environment-specific configurations and returns the merged result as `output`.
5. From each environment's root module (`environments/{env-name}/main.tf`), call the `modules/conf` module.
6. Pass the values received from the `conf` module when invoking other modules.

By following this approach, you can effectively manage environment-specific configurations in Terraform. It separates common configurations from environment-specific ones and allows for flexible configuration management. Furthermore, modularization enhances configuration reusability and maintainability.

This repository provides an example of managing Terraform configurations for different environments. Keep in mind that you should adapt the approach to fit your specific needs, considering security and best practices.

