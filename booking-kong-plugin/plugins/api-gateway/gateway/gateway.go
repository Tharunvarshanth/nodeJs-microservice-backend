package gateway

import (
	"github.com/Kong/go-pdk"
)

type Config struct {
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
	kong.Log.Info(url)
	kong.Response.SetHeader("Customer Header","Tharun")

}

