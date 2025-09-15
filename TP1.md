**TP1**

### 🌞 Déterminer quel algorithme de chiffrement utiliser pour vos clés
Ed25519 car des clés très forte et beaucoup plus courtes que RSA  


### 🌞 Générer une paire de clés pour ce TP
```
PS C:\Users\mouse> ssh-keygen -t ed25519 -f $env:USERPROFILE\.ssh\cloud_tp1 -C "cloud_tp1"
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in C:\Users\mouse\.ssh\cloud_tp1
Your public key has been saved in C:\Users\mouse\.ssh\cloud_tp1.pub
The key fingerprint is:
**** cloud_tp1
The key's randomart image is:
****
PS C:\Users\mouse>
```

### 🌞 Configurer un agent SSH sur votre poste
```
PS C:\Users\mouse> Get-Service ssh-agent | Set-Service -StartupType Automatic
>> Start-Service ssh-agent
PS C:\Users\mouse> ssh-add $env:USERPROFILE\.ssh\cloud_tp1
Identity added: C:\Users\mouse\.ssh\cloud_tp1 (cloud_tp1)
PS C:\Users\mouse>
PS C:\Users\mouse> ssh-add -l
****cloud_tp1 (ED25519)
PS C:\Users\mouse>
```
### 🌞 Connectez-vous en SSH à la VM pour preuve
```

PS C:\Users\mouse> ssh mouse@4.233.210.74
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1031-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Sep 15 08:15:18 UTC 2025

  System load:  0.0               Processes:             107
  Usage of /:   6.2% of 28.89GB   Users logged in:       0
  Memory usage: 33%               IPv4 address for eth0: 172.16.0.4
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

37 updates can be applied immediately.
28 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status

New release '24.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Mon Sep 15 07:58:52 2025 from 104.28.211.188
To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

mouse@vm-leo:~$
```
### 🌞 Créez une VM depuis le Azure CLI
```
C:\Users\mouse>az vm create --resource-group meo --name vm-cli --image Ubuntu2204 --admin-username mouse --ssh-key-values C:\Users\mouse\.ssh\cloud_tp1.pub --location francecentral --size Standard_B1s --public-ip-sku Standard
The default value of '--size' will be changed to 'Standard_D2s_v5' from 'Standard_DS1_v2' in a future release.
Selecting "northeurope" may reduce your costs. The region you've selected may cost more for the same services. You can disable this message in the future with the command "az config set core.display_region_identified=false". Learn more at https://go.microsoft.com/fwlink/?linkid=222571

{
  "fqdns": "",
  "id": "/subscriptions/11c686ac-e741-43c1-82bf-9967e9b9d5d8/resourceGroups/meo/providers/Microsoft.Compute/virtualMachines/vm-cli",
  "location": "francecentral",
  "macAddress": "60-45-BD-6D-4F-AF",
  "powerState": "VM running",
  "privateIpAddress": "172.16.0.5",
  "publicIpAddress": "51.103.103.119",
  "resourceGroup": "meo"
}

C:\Users\mouse>
```
### 🌞 Assurez-vous que vous pouvez vous connecter à la VM en SSH sur son IP publique
```
C:\Users\mouse>ssh mouse@51.103.103.119
The authenticity of host '51.103.103.119 (51.103.103.119)' can't be established.
ED25519 key fingerprint is SHA256:/X1crW1/Zzyw9YCu9wa42O3nJ57/DGrUZky2E8xkgO4.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.103.103.119' (ED25519) to the list of known hosts.
Welcome to Ubuntu 22.04.5 LTS (GNU/Linux 6.8.0-1031-azure x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Sep 15 08:50:59 UTC 2025

  System load:  0.08              Processes:             106
  Usage of /:   5.4% of 28.89GB   Users logged in:       0
  Memory usage: 31%               IPv4 address for eth0: 172.16.0.5
  Swap usage:   0%

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

mouse@vm-cli:~$
```
### 🌞 Vérification du service walinuxagent.service
```
Warning: The unit file, source configuration file or drop-ins of walinuxagent.service changed on disk. Run 'systemctl daemon-reload' to reload units.
● walinuxagent.service - Azure Linux Agent
     Loaded: loaded (/lib/systemd/system/walinuxagent.service; enabled; vendor preset: enabled)
    Drop-In: /run/systemd/system.control/walinuxagent.service.d
             └─50-CPUAccounting.conf, 50-MemoryAccounting.conf
     Active: active (running) since Mon 2025-09-15 08:23:50 UTC; 30min ago
   Main PID: 733 (python3)
      Tasks: 7 (limit: 1008)
     Memory: 47.5M
        CPU: 2.953s
     CGroup: /system.slice/walinuxagent.service
             ├─ 733 /usr/bin/python3 -u /usr/sbin/waagent -daemon
             └─1415 python3 -u bin/WALinuxAgent-2.14.0.1-py3.12.egg -run-exthandlers

Sep 15 08:24:02 vm-cli python3[1415]:        0        0 DROP       tcp  --  *      *       0.0.0.0/0            168.63.129.16        ctstate INVALID,NEW
Sep 15 08:24:02 vm-cli python3[1415]: 2025-09-15T08:24:02.247765Z INFO ExtHandler ExtHandler Looking for existing remote access users.
Sep 15 08:24:02 vm-cli python3[1415]: 2025-09-15T08:24:02.248927Z INFO ExtHandler ExtHandler [HEARTBEAT] Agent WALinuxAgent-2.14.0.1 is running as the goal state age>
Sep 15 08:29:02 vm-cli python3[1415]: 2025-09-15T08:29:02.218764Z INFO CollectLogsHandler ExtHandler WireServer endpoint 168.63.129.16 read from file
Sep 15 08:29:02 vm-cli python3[1415]: 2025-09-15T08:29:02.218890Z INFO CollectLogsHandler ExtHandler Wire server endpoint:168.63.129.16
Sep 15 08:29:02 vm-cli python3[1415]: 2025-09-15T08:29:02.218975Z INFO CollectLogsHandler ExtHandler Starting log collection...
Sep 15 08:29:12 vm-cli python3[1415]: 2025-09-15T08:29:12.838801Z INFO CollectLogsHandler ExtHandler Successfully collected logs. Archive size: 76547 b, elapsed time>
Sep 15 08:29:12 vm-cli python3[1415]: 2025-09-15T08:29:12.858553Z INFO CollectLogsHandler ExtHandler Successfully uploaded logs.
Sep 15 08:39:02 vm-cli python3[733]: 2025-09-15T08:39:02.043645Z INFO Daemon Agent WALinuxAgent-2.14.0.1 launched with command 'python3 -u bin/WALinuxAgent-2.14.0.1->
Sep 15 08:54:03 vm-cli python3[1415]: 2025-09-15T08:54:03.041632Z INFO ExtHandler ExtHandler [HEARTBEAT] Agent WALinuxAgent-2.14.0.1 is running as the goal state age>
~
~
~
~
~
~
~
~
~
~
~
~
~
~
~
lines 1-24/24 (END)
mouse@vm-cli:~$
```
### 🌞 Vérification du service cloud-init.service
```
mouse@vm-cli:~$ sudo systemctl status cloud-init.service
cloud-init status
● cloud-init.service - Cloud-init: Network Stage
     Loaded: loaded (/lib/systemd/system/cloud-init.service; enabled; vendor preset: enabled)
     Active: active (exited) since Mon 2025-09-15 08:23:49 UTC; 32min ago
   Main PID: 486 (code=exited, status=0/SUCCESS)
        CPU: 1.402s

Sep 15 08:23:49 vm-cli cloud-init[490]: |          .   o  |
Sep 15 08:23:49 vm-cli cloud-init[490]: |         .   =   |
Sep 15 08:23:49 vm-cli cloud-init[490]: |         ..   * .|
Sep 15 08:23:49 vm-cli cloud-init[490]: |        S... * oo|
Sep 15 08:23:49 vm-cli cloud-init[490]: |          E.+oO=.|
Sep 15 08:23:49 vm-cli cloud-init[490]: |         o =.+B+*|
Sep 15 08:23:49 vm-cli cloud-init[490]: |        . o =o+BO|
Sep 15 08:23:49 vm-cli cloud-init[490]: |          .=o*==X|
Sep 15 08:23:49 vm-cli cloud-init[490]: +----[SHA256]-----+
Sep 15 08:23:49 vm-cli systemd[1]: Finished Cloud-init: Network Stage.
mouse@vm-cli:~$
```
### 🌞 Utilisez Terraform pour créer une VM dans Azure
```

C:\Users\mouse\Desktop\LEO\M1-CLOUD>terraform init
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 3.0"...
- Installing hashicorp/azurerm v3.117.1...
- Installed hashicorp/azurerm v3.117.1 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

