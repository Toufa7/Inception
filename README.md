# Inception



[Docker](https://en.wikipedia.org/wiki/Docker,_Inc.) is a popular containerization technology that makes it easier to create, manage, and deploy containers. **(Containerization technology existed in Linux before Docker, but Docker made it more user-friendly and streamlined the process)** It is built on top of existing Linux technologies such as namespaces and cgroups, which are used to provide an isolated and controlled environment for running processes, while also ensuring that resource usage is limited and controlled.

> **Note**

>  Docker did not "take out" these technologies from Linux. Rather, Docker leveraged (profit) these technologies to make it easier to create and manage containers.


Docker runs on Windows and macOS by using a lightweight virtual machine called the **Docker Desktop VM** (it runs Linux as its OS). This Linux VM provides a platform for Docker to build and run containers just as if it were running on a native Linux system. The Docker Desktop VM is provided by the Windows Subsystem for Linux (WSL) on Windows and runs natively on macOS.


$\color{red}{Namespaces}$ are a mechanism for isolating system resources such as process IDs, network interfaces, file systems, and user IDs between different processes or groups of processes. Namespaces provide a way to create isolated environments, like a container, where a group of processes can have its own view of the system resources and separate from the host operating system and other containers. 


$\color{green}{Cgroups}$  are a kernel feature that allows the allocation of resources such as CPU time, memory, disk I/O, and network bandwidth to groups of processes. By using cgroups, Docker is able to limit the amount of resources that a container or a group of processes can use, which helps to ensure that the host system's resources are shared fairly among all running containers and processes.


The ``runc`` command allow us to creates a new container with a provided bundle directory as the root filesystem for the container and a config.json file in the bundle directory containing the configuration for the container.

When you create a container using a container runtime like ``runc`` you need to provide a root filesystem that will be used by the container. This allows the container to run as if it were a completely separate operating system, with its own set of files and directories that are isolated from the host system.

- The Root filesystem include all the files and directories that are necessary for the container to run, such as libraries, binaries, and configuration files (Ex: a directory containing a full Linux operating system, or just the files necessary to run a specific application.)

- The ``config.json`` is a configuration file that specifies various settings for the container, such as the command to run, environment variables, and networking settings 

[Simple example of config.json file with explaining](https://github.com/Toufa7/Inception_1337/blob/main/config.json)

If a container exceeds the memory or CPU limit specified in the ``config.json`` file, the kernel will start killing processes inside the container in an attempt to free up memory (this result slower performance , crashing and unresponsive), Therefore, it's important to carefully configure resource limits based on the needs of your application.

	    runc create <container-id> --bundle=<bundle-path>

* container-id	: is the name of the container
* bundle-path	: is the path to the bundle directory containing the root filesystem, the config file, and any other dependencies required by the container such as libraries, binaries

After the container is created, it can be started and managed using the runc start, runc stop, and runc delete commands, among others.


> **Note**

> With ``runc`` you can create containers without the need for Docker. However, it is important to note that runc is a lower-level tool compared to Docker and requires more manual configuration and setup, So n contrast Docker provides a higher-level interface and automates many of the container management tasks.

Docker uses both namespaces and cgroups to create and manage containers. By using these technologies, Docker is able to provide a lightweight and portable solution for running applications, without the need for a separate virtual machine. Docker uses the open-source container runtime called "runc" under the hood to create and manage containers. The Docker engine provides a higher-level interface for working with containers, including image management, networking, and storage. Docker communicates with runc through this interface to create and manage containers.

## Networking : 


Network Bridge:

- A virtual device that connects multiple containers together.
- It act like a Switch allowing containers to connect to each others and forwarding traffic between them.


Docker containers by default start attached to a bridge network called default.




## Resources :


Containers from scratch (Starting the isolation): 

Timeline : ``5:40`` ``9:07`` ``12:10`` ``13:36``

https://www.youtube.com/watch?v=_TsSmSu57Zo&ab_channel=ContainerCamp


## Commands :
## Using the default bridge network : 

1 - Here’s a simple example. I’ll start an nginx container. Then I’ll start a busybox container alongside nginx, and try to make a request to Nginx with wget (can they see each other let see ??):

	docker run --name mynginx --detach nginx

``--rm``		: to remove the container when it exits

``--name``		: option is used to specify a name for the container

``--detach``	: run the container in the background and detach it from the terminal

2 - Getting the IP Address of the NGINX:

	docker inspect | grep "IPAddress"

3 - Run busybox or any container that can provide a user-interaction

	docker run --name mybusybox busybox

4 - Can i see the Welcoming page of the Nginx Homepage !?

	wget -q -O - NGINX_IP_ADDRESS:PORT


اش بانلك 

this means that every container can see every other container.

## Creating a user-defined bridge network : 


1 - Create a user-defined bridge network :

	docker network create poms-network

to remove it make sure you stop your containers and use the command :

	docker network rm poms-network

2 - Start a container and connect it to the bridge :


	docker run --rm --net poms --name my_apache -d httpd


3 - Start a busybox container so that we can test out the network :

	docker run --net poms -it busybox


4 - Address another container, using its name as the hostname / or the IP Address :

	wget -q -O - APACHE_IP_ADDRESS:PORT


It’s a great way to have a custom network set up, and isolation from other containers that aren’t in the network


> Note

	docker network inspect <my-network / CONTAINER-ID>


This command used to view the details of a specific Docker network, also lists the containers connected to the network and their IP addresses

# Misunderstanding (Q&A):

* How can i evaluate how much should i put in the limits (Talking about config.json file)??

You may need to perform some performance testing to determine the optimal values for your environment (application or service).

* Is the limits in the config.json for bundling a container it's a explicit thing that need to set up by the user not by the a tool or something else or what ??

The limits for a container can be set explicitly by the user in the config.json file, However, the /proc file system in Linux provides a way for users and applications to view and manipulate the current state of the kernel and the system, including information about resource usage and limits

* Can containers connect to each other even though they are isolated ??

	Yes ... (to be continued)

By default, each container in Docker is isolated from the others and has its own network namespace. This means that each container has its own network stack and virtual network interfaces, and can have its own IP address, routing table, and network configuration independent of the host and other containers. However, Docker provides a variety of networking options that allow containers to communicate and share resources with each other if needed.


* Why docker bridge chose 172.16.X.X ??

Docker does not specifically choose 172.16.X.X as the default IP address range for the bridge network. This is defined in the Docker daemon configuration file and can be customized by the user.
cause it is a private IP address range that is not routable on the public internet and the Class B network 172.16.0.0/12 provides a large address space that can accommodate a large number of IP addresses for containers in the same network.

* Does Docker Inc take the Linux technologie and made Docker ??

Docker is built on top of existing Linux technologies such as namespaces and cgroups, 

Docker Inc. created a platform for building, shipping, and running applications in containers, using containerization technology. This platform provides a way to package applications and their dependencies into containers, and to deploy those containers to different environments.

Under the hood, Docker uses a combination of existing Linux technologies, including namespaces and cgroups, to provide an isolated environment for running containers. By using these technologies, Docker is able to provide a lightweight and portable solution for running applications, without the need for a separate virtual machine.





---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------Random--------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------Random--------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------Random--------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------Random--------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Random : 


## Kernel 

The kernel is a core component of an OS and serves as the main interface between the computer’s physical hardware and the processes running on it. The kernel enables multiple applications to share hardware resources by providing access to CPU, memory, disk I/O, and networking.

Imagine a computer as comprising a series of layers, with the innermost layer being the hardware, and the outermost layers being the software applications running on the computer. In this analogy, the kernel is positioned between the hardware and the applications because it’s not only responsible for managing the hardware’s resources and executing software programs, but also for overseeing the interactions between these layers.

Modern computers divide memory into kernel space and user space. User space is where application software is executed, while the kernel space is dedicated to the behind-the-scenes work needed to run a computer, like memory allocation and process management. Because of this separation of kernel and user spaces, the work done by the kernel isn’t typically visible to the user.







- Containerization technology existed in Linux before Docker came along.
- Docker essentially popularized and streamlined the process of creating and managing containers by providing a user-friendly interface and toolset.
- Docker is able to run on Windows and macOS through the use of virtualization technology (it uses a lightweight virtual machine called a "Docker Desktop VM" runs Linux as its operating system), This Linux VM provides a platform for Docker to build and run containers just as if it were running on a native Linux system (This is because the native Windows and macOS kernels do not have the same built-in support for containerization as Linux does).
- Even the processes inside the container are isolated, they are still running on your computer.
- This isolation allows multiple containers to run on the same host without interfering with each other, and it provides an additional layer of security by preventing processes inside a container from accessing resources outside the containe

## Namespace:

In Linux, a namespace is a mechanism for isolating system resources such as process IDs, network interfaces, file systems, and user IDs between different processes or groups of processes. Namespaces provide a way to create isolated environments, like a container, where a group of processes can have its own view of the system resources.

Namespaces are a key feature of containerization technology, as they enable the creation of isolated environments that can run multiple applications or services without interfering with each other or with the host operating system

Namespaces are a key tool used to create the isolated environment provided by a container. By using namespaces, containerization technologies like Docker are able to create an isolated environment that has its own view of the system resources like the file system, network interfaces, and process IDs

For example, when Docker creates a new container, it creates separate namespaces for the file system, network interfaces, and process IDs. This allows the container to have its own separate file system that is isolated from the host operating system's file system, its own virtual network interface that is isolated from the host's network interfaces, and its own process IDs that are separate from the PIDs of processes running on the host operating system

- Overall, namespaces provide a powerful tool for creating isolated environments that are used extensively in containerization technology to create the isolated environment provided by a container.

## Cgroups (Control groups):

It’s a key feature of containerization technology that is used to manage and limit the resource usage of processes running inside a container or a group of processes.

Cgroups are a kernel feature that allow the allocation of resources such as CPU time, memory, disk I/O, and network bandwidth to groups of processes. By using cgroups, containerization technologies like Docker are able to limit the amount of resources that a container or a group of processes can use, which helps to ensure that the host system's resources are shared fairly among all running containers and processes.


## Docker uses both namespaces and cgroups to create and manage containers:

When Docker creates a new container, it creates separate namespaces for the container's file system, network interfaces, process IDs, and other system resources. This allows the container to have its own isolated environment, with its own view of the system resources, separate from the host operating system and other containers.

At the same time, Docker also uses cgroups to limit the resource usage of the container, such as CPU time, memory, and disk I/O. This ensures that the container's resource usage is controlled and does not interfere with other containers or the host operating system.

Overall, namespaces and cgroups are two key features used in containerization technology to create and manage containers. By using namespaces and cgroups, containerization technology like Docker is able to provide an isolated and controlled environment for running processes, while also ensuring that the resource usage is limited and controlled.




## Key points:

* Docker is a technology that provides an isolated environment for running applications as containers.
* Containers are a lightweight alternative to virtual machines, providing an isolated environment for running processes without the overhead of a full virtual machine.
* Docker uses technologies like namespaces and cgroups to create isolated environments for containers.
* Namespaces provide an isolated view of system resources, such as the filesystem, network interfaces, and process IDs.
* Cgroups provide resource management for containers, allowing you to limit the amount of CPU, memory, and other resources that a container can use.
* Docker uses these technologies to create and manage containers, allowing you to package applications and their dependencies into a portable and self-contained unit.
* When Docker is run on Windows or macOS, it uses a lightweight virtual machine called Docker Desktop to provide support for containerization.
* The Docker Desktop VM provides a Linux environment that can run Docker containers, and it also includes the necessary Docker components.
* When Docker is run on Linux, it uses the Linux kernel's built-in support for containerization and does not require a separate VM.
* Overall, Docker provides a powerful and flexible tool for building, deploying, and managing containerized applications across different platforms and environments.


## Virtualization  (VS) Containerization:


- Resource Usage:

Virtualization creates a complete virtual machine that includes its own operating system and resources
Containerization shares the host operating system and only isolates resources using namespaces.

- Security:

Virtual machines provide strong isolation between different virtual machines, because they have their own operating systems.
Containers have weaker isolation, because they share the host operating system and kernel, but they can still provide effective isolation using namespaces and other security measures.

- Portability:

Virtualization are highly portable because they encapsulate an entire operating system and its applications into a single package. This means that a VM can be moved between different physical hosts or cloud environments without requiring any changes to the guest operating system or applications. However, VMs can be relatively heavy and slow to start up, which can impact their portability in certain situations. 
Containerization are also highly portable, but they achieve portability in a different way. Instead of encapsulating an entire operating system, containers encapsulate a single application and its dependencies. This means that a container can be moved between different physical hosts or cloud environments while retaining (keeping) the same underlying host operating system.

Containers are typically much lighter and faster to start up than VMs, which makes them highly portable and well-suited for modern cloud environments.



<p align="center" /p>
<img src="https://joearms.github.io/images/con_and_par.jpg" width="400">
 
<p align="center" /p>
<img src="https://pbs.twimg.com/media/EQGomZFWoAYIU3T.jpg" width="1000">
  
<p align="center" /p>
<img src="https://pbs.twimg.com/media/EJgR3NeXYAAFMaj.jpg:large" width="1000">

<p align="center" /p>
<img src="https://miro.medium.com/v2/resize:fit:1400/format:webp/1*oQBStcYmbbtP5n58I1Lb_A.png" width="600">

<p align="center" /p>
<img src="https://blogs.sap.com/wp-content/uploads/2018/06/Container_vs_VM.png" width="700">
