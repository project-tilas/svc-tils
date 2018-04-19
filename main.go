package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

type (
	health struct {
		ServiceName string `json:"serviceName"`
		Alive       bool   `json:"alive"`
	}
)

var version string
var port string

func init() {
	fmt.Println("Running SVC_TILS version: " + version)
	port = os.Getenv("SVC_TILS_PORT")
	if port == "" {
		port = "8080"
	}

}

func main() {
	// Echo instance
	e := echo.New()

	// Middleware
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	// Route => handler
	e.GET("/health", func(c echo.Context) error {
		u := health{Alive: true, ServiceName: "svc-tils"}
		return c.JSON(http.StatusOK, u)
	})

	// Start server
	e.Logger.Fatal(e.Start(":" + port))
}
