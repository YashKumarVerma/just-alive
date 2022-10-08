package main

import (
	"github.com/ansrivas/fiberprometheus/v2"
	"github.com/gofiber/fiber/v2"
	httpLogger "github.com/gofiber/fiber/v2/middleware/logger"
)

func main() {
	app := fiber.New()

	// shift logger at end to ignore metrics and health check routes
	app.Use(httpLogger.New(httpLogger.Config{
		Format:   "${pid} ${locals:requestid} ${status} - ${method} ${path} ${body}\n",
		TimeZone: "Asia/Kolkata",
	}))

	app.Get("/health", func(c *fiber.Ctx) error {
		return c.SendString("ok")
	})

	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendString("ok")
	})

	prometheus := fiberprometheus.New("just-alive")
	prometheus.RegisterAt(app, "/metrics")
	app.Use(prometheus.Middleware)

	app.Listen(":80")
}
