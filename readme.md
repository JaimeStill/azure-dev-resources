# Offline Dev Resources

With the establishment of the [IL6 cloud region](https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-dod-il6#azure-and-dod-il6), we now have access to the services necessary for hosting capabilities in the cloud environment. In order to leverage these services, we still need to establish the underlying infrastructure needed to develop and deploy these capabilities. This repository is an effort to identify this needed infrastructure, and identify strategies for standardizing their use in an environment without access to the internet.

See:

* [Documentation](https://jaimestill.github.io/azure-dev-resources) - outlines the resources needed to facilitate an offline development environment with access to the [IL6 cloud region](https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-dod-il6#azure-and-dod-il6), as well as strategies for acquiring and managing those resources at an enterprise level.

    * [Dev Environment Setup](./docs/dev-environment-setup.md) - procedures for installing all of the resources on a development machine with no internet connection.

* [Automated Resource Builds](./docs/index.md#automated-resource-builds) - automates the process of generating resources necessary for setting up an offline development environment with access to [IL6 cloud region](https://learn.microsoft.com/en-us/azure/compliance/offerings/offering-dod-il6#azure-and-dod-il6c) region.

* [Scripts](./scripts) - scripts that facilitate the automated resource builds.

* [Lab](./lab/) - initial concept development before integrating features into the official [scripts](./scripts).

* [Project Board](https://github.com/users/JaimeStill/projects/5) - tracks all of the work associated with this endeavor.