package gin

import (
	"github.com/gin-gonic/gin"
)

var router *gin.Engine

//config holds all of the environment variables for mysql db configuration.
type config struct {
	Username    string `env:"MYSQL_USERNAME" envDefault:"sezzle_admin"`
	Password    string `env:"MYSQL_PASSWORD" envDefault:"banana"`
	Hostname    string `env:"MYSQL_HOSTNAME" envDefault:"localhost"`
	Port        int    `env:"MYSQL_PORT" envDefault:"3306"`
	Name        string `env:"MYSQL_NAME" envDefault:"instantach"`
	Environment string `env:"APP_ENV" envDefault:"local"`
}

//Run starts a Gin server.
func Run() {
	router.Run(":10000")
}

func init() {
	router = InitRoutes()
}
