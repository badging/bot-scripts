**bot-scripts** contains the program(s) used to install and setup the [badging-bot](https://github.com/badging/badging-bot) on a user local machine. 
The major program/script used for this installation is the [install.sh script](https://github.com/badging/bot-scripts/blob/main/install.sh). This script contains the workflow for the badging-bot setup based on the operating system of a user (MacOS, Linux and Windows).


# Setup badging-bot with bot-scripts 
## Linux and MacOS
### Prerequisite
- Install curl
- Local machine user should have sudoprivileges.
### Webhook and Github App
- Create an access token (https://github.com/settings/tokens) and save it in local secret file.
- Create a webhook
    - Visit https://smee.io
        - Click on `Start a new channel`
        - Copy the `Webhook Proxy URL` and save in your secrets file. Note:
            - This URL is what will be required to view the events in later sections.
            - This will be supplied on script runtime as the `Webhook URL`
- Setup app:
    - Visit https://github.com/settings/apps/new
        - Register a new GitHub App (Section)
            - GitHub App name: `$your_desired_app_name`
            - Description: `App responsible for event-diversity-and-inclusion badging-bot`
            - Homepage URL (website used by the GitHub App.): `https://handbook.chaoss.community/community-handbook/badging/overview`. You can add your desired website of choice here.
            - 
        - Identifying and authorizing users (**Leave as it is**)
        - Post installation (**Leave as it is**)
        - Webhook
            - Webhook URL: `$Webhook_URL`
            - Webhook secret (optional): `$your_secret`
                - Don't forget to store this in your secret file
            - SSL verficiation: **Enable SSL verification**
        - Permissions
            - Repository permissions
                - Set all accesses to Read and Write (28 selected)
                    - Exceptions:
                        - **Single file** set to No Access.
                        - **Metadata** access maximimum permission is Read-only.
                        - **Codespaces metadata** maximimum permission is Read-only.
            - Organization permissions
                - (**Leave as it is**)
            - Account permissions
                - (**Leave as it is**)
        - Subscribe to events
            - Based on the permissions you’ve selected, what events would you like to subscribe to? 
                - **Check all boxes** if you would like to.
            - Where can this GitHub App be installed? **Only on this account**
        - Click **Create GitHub App**
    - On the newly created app webpage (https://github.com/settings/apps/$your_desired_app_name)
        - Copy the `App ID` and `Client ID` into your secret file.
        - Client secrets
            - Click `Generate a new client secret`
                - Make sure to copy your new client secret and save in your secret file
        - Private keys
            - Click `Generate a private key`
                - This downloads to your local machine with the name, `$appName.$date.private-key.pem`. Please move it to a place of easy accessibility and take note of its path (e.g. `/home/$user/$your_desired_app_name.$date.private-key.pem`)
        - (Optional) Display information: Add a cool logo :)
        - Leave all previous setting as it is and click **Save changes**.

## Local Script Run
```
$ source <(curl -s https://raw.githubusercontent.com/badging/bot-scripts/main/install.sh)
```
If the source approach above does not work, an alternative would be to clone this repository and run:
```
$ chmod +x install.sh
$ bash install.sh
```

---Runtime arguments---
Enter Github username: $GitHub_Username
Enter Github email: $username@gmail.com
? What account do you want to log into? GitHub.com
? What is your preferred protocol for Git operations? HTTPS
? Authenticate Git with your GitHub credentials? Yes
? How would you like to authenticate GitHub CLI? Paste an authentication token
? Paste your authentication token: $GitHub_Access_token
Enter Webhook URL: $Webhook_URL
Enter Webhook Secret: $Webhook_Secret
Enter App Id: $App_Id
Enter Client Id: $Client_Id
Enter Client Secret: $Client_Secret
Enter FULL PATH to downloaded PEM file: /home/$user/$appName.$date.private-key.pem
Have you installed the test app on your forked event-diversity-and-inclusion repository? (y/n): n
---Continue with steps below---
...
- Access the previously created GitHub App through;
    - https://github.com/settings/apps/$appName, or
    - Settings >> Developer settings >> GitHub Apps
- While in the https://github.com/settings/apps, from the left menu, click `Install App`
    - Click `Install` on your account
        - Install on your personal account `$Account_Name`
            - Only select repositories
                - Select repositories: `$GitHub_Username/event-diversity-and-inclusion`
        - Click `Install` 
- Return to your terminal and input `y` for `Have you installed the test app on your forked event-diversity-and-inclusion repository?`

```
Have you installed the test app on your forked event-diversity-and-inclusion repository? (y/n): y
...
[nodemon] 2.0.15
[nodemon] to restart at any time, enter `rs`
[nodemon] watching path(s): *.*
[nodemon] watching extensions: js,mjs,json
[nodemon] starting `node index.js`
info: App listening on PORT:2020
```
