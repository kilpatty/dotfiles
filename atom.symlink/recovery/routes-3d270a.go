package gin

import (
	"sezzle/instantach/authentication"
	"sezzle/instantach/core"
	"sezzle/instantach/core/customerpanel"
	"time"

	"github.com/gin-gonic/gin"
	cors "github.com/itsjamie/gin-cors"
)

// InitRoutes : Creates all of the routes for our application and returns a router
func InitRoutes() *gin.Engine {

	// Create a new Gin Router.
	router := gin.New()

	//Set Global Middleware
	r.Use(gin.Logger())
	r.Use(gin.Recovery())

	// CORS Middleware
	router.Use(cors.Middleware(cors.Config{
		Origins:         "*",
		Methods:         "GET, PUT, POST, DELETE",
		RequestHeaders:  "Origin, Authorization, Content-Type",
		ExposedHeaders:  "",
		MaxAge:          50 * time.Second,
		Credentials:     true,
		ValidateHeaders: false,
	}))

	router.Use()

	//Set the routes for our application
	SetAccountRoutes(router)
	SetTransactionRoutes(router)
	SetAdminRoutes(router)
	SetUserRoutes(router)
	//Remove in production
	SetTestRoutes(router)
	SetLoginLogoutRoutes(router)
	SetSignupRoutes(router)

	SetCustomerPanelRoutes(router)
	return router
}

//SetUserRoutes : Sets all the routes for this router.
func SetUserRoutes(router *gin.Engine) {

	router.POST("/customer/", core.HandleCreateUser)

	router.POST("/login/customer/", core.HandleUserLogin)
	//router.GET("/customer/:token")
	// router.POST("/merchant/", core.HandleCreateMerchantUser)
	// router.POST("/merchant/:token", validengine.HandleCreateMerchantAccount)
}

//SetTransactionRoutes : Sets all the routes for this router.
func SetTransactionRoutes(router *gin.Engine) {

	// router.POST("/transaction/", transengine.HandleCreateTransaction)
	// //Token should be the UUID of the transaction.
	// router.GET("/transaction/:token", transengine.HandleReturnTransaction)

}

//SetSignupRoutes : Sets all routes user for customer signup
func SetSignupRoutes(router *gin.Engine) {

	//Account and user signup routes for frontend
	router.POST("/accounts/customer-signup/", core.HandleUserSignup)
	router.POST("/accounts/customer-signup/verify/", core.HandleUserLogin)

	router.POST("/accounts/customer-signup/profiles/", core.HandleSignupProfile)
	router.OPTIONS("/accounts/customer-signup/profiles/", core.HandleSignupProfileOptions)

	router.POST("/accounts/customer-signup/account/login/", core.HandleBankAccountLogin)
	router.OPTIONS("/accounts/customer-signup/account/login/", core.HandleBankAccountLogin)

	router.POST("/accounts/customer-signup/loginlink/", core.HandleLoginLink)
	router.OPTIONS("/accounts/customer-signup/loginlink/", core.HandleLoginLink)
}

//SetLoginLogoutRoutes : sets all necessary routes for user login and logout
func SetLoginLogoutRoutes(router *gin.Engine) {

	//Login routes
	router.POST("/accounts/login/", core.HandleUserLogin)
	router.OPTIONS("/accounts/login/", core.HandleUserLoginOptions)

	//Not currently being used
	router.POST("/accounts/login/otp/", core.HandleUserLoginOTP)

	//Logout routes
	router.GET("/accounts/logout/", core.HandleUserLogout)
	router.OPTIONS("/accounts/logout/", core.HandleUserLogoutOptions)
}

func SetCustomerPanelRoutes(router *gin.Engine) {
	authenticatedRouter := router.Use(authentication.JWTAuthMiddleware())
	router.OPTIONS("/customer/customer-dashboard/transactions/", customerpanel.HandleUserTransactionListOptions)
	authenticatedRouter.GET("/customer/customer-dashboard/transactions/", customerpanel.HandleUserTransactionList)

	router.OPTIONS("/customer/customer-dashboard/transactions/:txid/", customerpanel.HandleUserTransactionOptions)
	authenticatedRouter.GET("/customer/customer-dashboard/transactions/:txid/", customerpanel.HandleUserTransaction)
}

//SetAccountRoutes : Creates the proper routes for the Account (Bank account) object
func SetAccountRoutes(router *gin.Engine) {

	router.GET("/customer/customer-dashboard/profiles/me/", core.HandleUserProfile)
	router.OPTIONS("/customer/customer-dashboard/profiles/me/", core.HandleUserProfileOptions)

	//router.OPTIONS("/customer/customer-dashboard/transactions/", core.HandleUserTransactionsOptions)
	//router.GET("/customer/customer-dashboard/transactions/", core.HandleUserTransactions)

	router.GET("/customer/customer-dashboard/profiles/addresses/", core.HandleUserAddresses)
	router.OPTIONS("/customer/customer-dashboard/profiles/addresses/", core.HandleUserAddressesOptions)

	router.GET("/customer/customer-dashboard/accounts/", core.HandleUserAccounts)
	router.OPTIONS("/customer/customer-dashboard/accounts/", core.HandleUserAccountsOptions)

	router.GET("/customer/customer-dashboard/authorizations/", core.HandleUserAuthorizations)
	router.OPTIONS("/customer/customer-dashboard/authorizations/", core.HandleUserAuthorizationsOptions)

	router.GET("/customer/customer-dashboard/profiles/notifications/me/", core.HandleUserNotifications)
	router.OPTIONS("/customer/customer-dashboard/profiles/notifications/me/", core.HandleUserNotificationsOptions)
	router.PUT("/customer/customer-dashboard/profiles/notifications/3/", core.HandleUserNotificationsChange)

	router.POST("/customer/customer-dashboard/helps/", core.HandleUserHelp)
	router.OPTIONS("/customer/customer-dashboard/helps/", core.HandleUserHelpOptions)

	// router.POST("/customer/:token/mfa", validengine.HandleSubmitMFA)

	//Merchant Account
	//router.GET("/account", validengine.HandleGetAccount)
	// router.GET("/accounts")
	// router.GET("/account/:token")
	// router.GET("/account/:token/balance")
	// router.DELETE("/account/:token")
}

//SetAdminRoutes : Creates routes for admin model endpoints
func SetAdminRoutes(router *gin.Engine) {
	// router.POST("/admin/create", validengine.HandleCreateAdminAccount)

}
