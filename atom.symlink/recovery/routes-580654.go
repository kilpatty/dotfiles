package gin

import (
	"time"

	"github.com/gin-gonic/gin"
	cors "github.com/itsjamie/gin-cors"
)

// InitRoutes : Creates all of the routes for our application and returns a router
func InitRoutes() *gin.Engine {

	router := gin.New()

	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	// Apply the middleware to the router (works with groups too)
	router.Use(cors.Middleware(cors.Config{
		Origins:         cfg.Origins,
		Methods:         "GET, PUT, POST, DELETE",
		RequestHeaders:  "Origin, Authorization, Content-Type, X-SezzleInc-OTP",
		ExposedHeaders:  "",
		MaxAge:          50 * time.Second,
		Credentials:     true,
		ValidateHeaders: true, //Should be true for production. - is more secure because we validate headers as opposed to ember.
	}))

	v1 := router.Group("/v1")
	{
		authorized := v1.Group("/", JWTAuthMiddleware())
		cd := authorized.Group("/customer/customer-dashboard")
		SetCustomerDashboardRoutes(cd)
	}
	return router
}

//SetCustomerDashboardRoutes sets all of the routes for customer dashboard.
func SetCustomerDashboardRoutes(g *gin.RouterGroup) {
	//We can probably make this a little bit better by
	g.GET("/profiles/me", HandleUserProfile)
	g.GET("/transactions", HandleUserTransactions)
	g.GET("/profiles/addresses", HandleUserAddresses)
	g.GET("/accounts", HandleUserAccounts)
	g.GET("/authorizations", HandleUserAuthorizations)
	router.GET("/profiles/notifications/me", HandleUserNotifications)
	router.PUT("/profiles/notifications/3", HandleUserNotificationsChange)
	router.POST("/helps", HandleUserHelp)
}
