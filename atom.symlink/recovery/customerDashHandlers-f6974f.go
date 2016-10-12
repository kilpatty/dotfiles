package gin

import (
	"fmt"
	"net/http"
	"sezzle/instantach/JWT"
	"sezzle/instantach/config"
	"sezzle/instantach/notifications"
	"time"

	"github.com/asaskevich/govalidator"
	"github.com/gin-gonic/gin"
	"github.com/golang/glog"
)

var (
	//FrontEndHost : Host for the Customer dashboard frontend
	FrontEndHost = config.FrontEndHost
)

//AccountRequest : Bank account login credentials
type AccountRequest struct {
	Institution string `json:"institution"`

	Username string `json:"username"`
	Password string `json:"password"`
}

//HandleCreateAccount : Router handler for creating an account
func HandleCreateAccount(c *gin.Context) {

	userID := c.Query("id")

	request := AccountRequest{}
	err := c.BindJSON(&request)
	if err != nil {
		glog.Info(err)
		c.String(500, err.Error())
		return
	}
	glog.Info(userID)

	//Get user from db

	//Check authorization or session
	// user, err := objects.GetUserByID(userID)
	// if err != nil {
	// 	glog.Info(err)
	// 	w.Write([]byte(err.Error()))
	// 	return
	// }
	//
	// w.Write([]byte(user.FirstName + " From db lookup"))

	// type UserSignupPhonePost struct {
	// 	PhoneNumber string `json:"phone"`
	// }

	/* PRE - JWT Code
	// //Check if user exists by phone number
	// if login.UserAlreadyExists() == true {
	// 	http.Error(w, `{"phone":["Phone is already registered"]}`, 400)
	// 	return
	// }

	// //Create user and set pin to Pending for searches on existing users
	// newUser := objects.User{
	// 	UserPhone: objects.UserPhone{
	// 		Phone: objects.Phone{
	// 			Number: login.UserPhone.Phone.Number,
	// 		},
	// 	},
	// }

	// err := newUser.Save()
	// if err != nil {
	// 	glog.Info(err)
	// 	http.Error(w, `{"detail": "Error creating user"}`, 400)
	// 	return
	// }

	// userSignup := objects.UserSignup{
	// 	PhoneNumber:   newUser.UserPhone.Phone.Number,
	// 	PhoneEntered:  true,
	// 	PhoneVerified: false,
	// }

	// err = userSignup.Save()
	// if err != nil {
	// 	glog.Info(err)
	// 	http.Error(w, "Internal server error", 500)
	// }

	// jsonResponse := fmt.Sprintf(`{"otp": "%s", "signup_token": "%d"}`, otp.Hash, otp.UserID)

	// http.Error(w, jsonResponse, 204)

	*/

	expireToken := time.Now().Add(time.Minute * 15).Unix()

	token := JWT.SetToken(1, nil, expireToken)

	//Create our Json response here to return the token.
	responseJSON := fmt.Sprintf(`{"token": "%s"}`, token)

	//Write the Json back to the FrontEnd.
	c.String(200, responseJSON)
}

//HandleSignupProfile : Handles customer dashboard user information submission
func HandleSignupProfile(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken")

	// user := objects.User{}

	request := NewUserRequest{}

	err := c.BindJSON(&request)
	if err != nil {
		glog.Info(err)
		c.String(500, err.Error())
		return
	}

	result, err := govalidator.ValidateStruct(request)
	if err != nil {
		glog.Info(err)
	}
	glog.Info(result)

	user, err := request.CreateInstantACHUser()
	if err != nil {
		glog.Info(err)
		c.String(500, err.Error())
		return
	}

	if user.ID == 0 {
		glog.Info("User was not saved properly")
		c.String(500, "Interntal Service error")
	}

	responseJSON := fmt.Sprintf(`{"signup_token": "%d"}`, user.ID)
	notifications.SendEmail(request.Email)
	c.String(200, responseJSON)
}

//HandleUserProfile handles the profile/me endpoint
func HandleUserProfile(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")

	//Grab the User ID from the Token.

	//Retreive all of the data about the user.

	// user := objects.User{}

	// objects.GetUserByID()

	// responseJSON := fmt.Sprintf("Test")

	//Placeholder : This is the expected response by the front end
	responseJSON := fmt.Sprint(`{
   "id":3,
   "user":{
      "id":1000002,
      "email":"seanpkilgarriff@gmail.com",
      "first_name":"Sean",
      "last_name":"Kilgarriff",
      "email_verified":false,
      "user":"612-309-5839"
   },
   "reward_points_balance":0,
   "primary_account_ach":null,
   "last_activity":"2016-09-06T18:44:00.570539Z"
}`)

	c.String(200, responseJSON)
}

//HandleUserProfileOptions returns the proper headers for CORS requests.
func HandleUserProfileOptions(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")

}

//HandleSignupProfileOptions : Handles the Preflight Options request
func HandleSignupProfileOptions(c *gin.Context) {

	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")

	//userID := c.MustGet("userID").(uint)
}

//HandleUserTransactions returns all of the user's transactions.
func HandleUserTransactions(c *gin.Context) {

	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")

	responseJSON := fmt.Sprint(`{"count":0,"next":null,"previous":null,"current_page":1,"total_pages":1,"results":[]}`)
	c.String(200, responseJSON)

}

//HandleUserTransactionsOptions handles the precheck for headers for transactions.
func HandleUserTransactionsOptions(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")
}

//HandleUserAddresses handles the settings url in ember.
func HandleUserAddresses(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")

	userID := c.MustGet("userID")

	u = new(User)

	ba, err := auth.User.GetBillingAddressesByID(userID)
	if err != nil {
		c.String(400, err.Error())
	}

	c.JSON(200, ba)
}

//HandleUserAddressesOptions handles the options request for ember.
func HandleUserAddressesOptions(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")
}

//HandleUserAccounts returns back the bank accounts of the user.
func HandleUserAccounts(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")

	responseJSON := fmt.Sprint(`[]`)
	c.String(200, responseJSON)
}

//HandleUserAccountsOptions sets the headers for the precall to accounts.
func HandleUserAccountsOptions(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")
}

//HandleUserAuthorizations returns the preapproved payments for the user.
func HandleUserAuthorizations(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")

	responseJSON := fmt.Sprint(`[]`)
	c.String(200, responseJSON)
}

//HandleUserAuthorizationsOptions prepares the headers for this endpoint.
func HandleUserAuthorizationsOptions(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")
}

//HandleUserNotifications handles the return of the notification specifications for the user.
func HandleUserNotifications(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")

	responseJSON := fmt.Sprint(`{
   "id":3,
   "payment_made_notification_text":true,
   "payment_made_notification_email":true,
   "rewards_earned_notification_text":true,
   "rewards_earned_notification_email":true,
   "account_changes_notification_text":true,
   "account_changes_notification_email":true
}`)
	c.String(200, responseJSON)
}

//HandleUserNotificationsOptions handles the option headers for the above request.
func HandleUserNotificationsOptions(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")
}

//HandleUserNotificationsChange makes a change to the user's notifications preferences in the db.
func HandleUserNotificationsChange(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")
}

//HandleUserHelp sends the help email for the user.
func HandleUserHelp(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")

	//Needed as Ember is waiting for a 204 response.
	c.Writer.WriteHeader(http.StatusNoContent)
}

//HandleUserHelpOptions sets the headers for the prequest
func HandleUserHelpOptions(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")
}

//HandleUserLogout logs out the user.
func HandleUserLogout(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")
}

//HandleUserLogoutOptions handles the headers for logout
func HandleUserLogoutOptions(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization")
}

//HandleUserLoginOptions :
func HandleUserLoginOptions(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken, Authorization, X-SezzleInc-OTP")
}

//BankLogin : Login struct for bank baluse
type BankLogin struct {
	Username string `json:"username"`
	Password string `json:"password"`
	// Pin string `json:"string"`
}

//HandleCreateUser : Creates an instant ach user
func HandleCreateUser(c *gin.Context) {
	request := NewUserRequest{}

	err := c.BindJSON(&request)
	if err != nil {
		glog.Info(err)
		c.String(500, err.Error())
		return
	}

	user, err := request.CreateInstantACHUser()
	if err != nil {
		glog.Info(err)
		c.String(500, err.Error())
		return
	}

	c.String(200, "User first name: "+user.FirstName)
	return
}

//HandleBankAccountLogin : Handles bank account login submission
func HandleBankAccountLogin(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken")

	login := BankLogin{
		Password: c.PostForm("password"),
		Username: c.PostForm("username"),
	}

	responseJSON := fmt.Sprintf(`{"username": "%s", "password": "%s"}`, login.Username, login.Password)
	c.String(200, responseJSON)
}

//HandleUserLoginOTP handles the otp response from ember.
func HandleUserLoginOTP(c *gin.Context) {

	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken")

	responseJSON := fmt.Sprint(`{"status":"success","data":{"customer":{"phone":"612-309-5839","first_name":"Sean","last_name":"Kilgarriff","email":"seanpkilgarriff@gmail.com","id":"1000002","whitelabel":1}}}"`)
	c.String(200, responseJSON)
}

//HandleLoginLink : Login Link for redirect to customer dashboard
func HandleLoginLink(c *gin.Context) {
	c.Header("Access-Control-Allow-Origin", FrontEndHost)
	c.Header("Access-Control-Allow-Credentials", "true")
	c.Header("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRFToken")
	email := notifications.Email{}
	email.To = "killianbrackey@gmail.com"
	// email.SendEmail()
}
