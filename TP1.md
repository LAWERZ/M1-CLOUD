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
