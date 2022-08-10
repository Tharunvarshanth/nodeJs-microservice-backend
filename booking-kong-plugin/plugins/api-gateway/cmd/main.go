package main

import (
	"log"

	"github.com/Kong/go-pdk/server"
	"github.com/tharun/plugins/api-gateway/gateway"
)

const Version = "Development"

func main() {
	log.Printf("Starting Booking Api Gateway Plugin %s", Version)

	if err := server.StartServer(gateway.New(), Version, 1); err != nil {
		log.Fatalf("unable to start the plugin server, %v", err)
	}
}
