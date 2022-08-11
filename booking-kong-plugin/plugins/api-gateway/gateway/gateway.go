package gateway

import (
	"fmt"

	"github.com/Kong/go-pdk"
)

type Config struct {
	Minute string
}

func New() func() interface{} {
	return func() interface{} {
		return &Config{

		}
	}
}


func (c *Config) Access(kong *pdk.PDK) {
    url,err :=kong.Request.GetPath();
	if err !=nil{
		kong.Response.ExitStatus(500)
		return;
	}
	kong.Log.Info(fmt.Sprintf("%s",url))
	kong.Response.SetHeader("Config Minute",c.Minute)
	kong.Response.SetHeader("Customer Header","Tharun")

}

