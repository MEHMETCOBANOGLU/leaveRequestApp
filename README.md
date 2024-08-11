## Project Overview

The leave tracking application we are developing is designed to streamline the leave management process for employees and enable managers to efficiently manage leave requests. The application is being developed using Flutter.

### Key Features

- **Login and Authorization System:** Users can access the application through a secure login screen with authorization. Both employees and managers can log into their accounts and manage their leave requests.

- **Department-Based Leave Management:** Employees' department information is recorded, and leave requests are routed to the relevant department managers. This feature facilitates direct communication between employees and their department managers.

- **Leave Request Details:** Employees can specify the number of leave days, the reason for the leave, and other necessary details via a form within the application. The information is then displayed in the leave section of the admin's page, where the admin can approve or deny the request. A message button is also available for communication.

- **Employee-Admin Communication:** Employees can communicate with department managers about their leave requests through a chat section. Managers can quickly evaluate requests and interact with employees as needed.

- **User Activation:** Admins can assign usernames and passwords to registered users through the user activation page, providing them with the necessary credentials to access the system.

---
![image](https://github.com/user-attachments/assets/5e03e893-ac9c-4351-a538-b9f4f348820c)

When personnel logs in, the leave request page [see Appendix 1] will appear. By clicking the leave button at the bottom right, the leave status page [see Appendix 2] will open, where they can view their submitted leave requests and check the approval status.

![image](https://github.com/user-attachments/assets/a1201796-9f59-438d-9ef4-235db1142a88)
---
When an admin logs in, they will be greeted by a page displaying the leave requests [see Appendix 3]. From this page, the admin can review the details of the leave requests, approve or reject them, send a message [see Appendix 4], or delete the leave request.

![image](https://github.com/user-attachments/assets/5e339886-2c26-49ef-8d2a-f5de82cefca7)
---
When the user activation option is selected from the bottom bar, the user activation page [see Appendix 5] will appear. On this page, the admin can view the information of the registered users and, if deemed appropriate, activate the user by clicking the corresponding button, which will redirect them to the activation page [see Appendix 6].

![image](https://github.com/user-attachments/assets/f31b1972-f9de-46bf-b807-fa22730439ca)

## 🛠️ Installation Steps


1. Open Terminal and Clone the Repo

```bash
  git clone https://github.com/MEHMETCOBANOGLU/leaveRequestApp.git
```
 2. Cd Over 
 
```bash
   cd leaveRequestAppleaveRequestApp

```
 3. Run Pub
```
   Flutter pub get
```
4. Creating Native Splash
```
  flutter pub run flutter_native_splash:create
```
5. Run App 
```
  Happy Coding !!
```
