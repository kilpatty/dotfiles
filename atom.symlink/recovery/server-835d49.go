package main

import (
	"flag"
	_ "net/http/pprof"
	"sezzle/instantach/db"
	"sezzle/instantach/objects"

	"github.com/golang/glog"
)

func main() {
	//Snag all flags that our application is run on.
	flag.Parse()
	flag.Lookup("alsologtostderr").Value.Set("true")

	glog.Info("Retreiving Environment Variables...")

	//Initalize our db.
	glog.Info("Initalizing db...")
	err := db.InitDB()
	if err != nil {
		glog.Fatal("Could not initalize db", err.Error())
	}

	//Defer this so that if our application exits, we close the db.
	//Double check this.
	defer db.DB.Close()

	glog.Info("Initalizing Models...")

	err = objects.Migrate()
	if err != nil {
		glog.Fatal("Could not run object migrations.")
	}

	gin.Run()
}
