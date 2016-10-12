package objects

import (
	"sezzle/instantach/db"

	"github.com/jinzhu/gorm"
)

//ShippingAddress : Placeholder for build. Required by User in user.go
type ShippingAddress struct {
	gorm.Model
	UserID  uint
	Default bool

	Street     string               `json:"sa_street"`
	Street2    string               `json:"sa_street2"`
	City       string               `json:"sa_city"`
	State      AddressStateCodeType `json:"sa_state"` //Constants table defining all the states in the USA see AddressMaps
	PostalCode string               `json:"sa_postal_code"`
	Country    AddressCountryType   `json:"sa_country_code"` //Constants of the different country codes.
}

//Create : Creates a new Address
func (sa *ShippingAddress) Create() error {
	err := db.DB.Create(sa).Error
	if err != nil {
		return err
	}

	return err
}

//Update updates the specific shipping address in the db.
func (sa *ShippingAddress) Update() error {

}

func (sa *ShippingAddress) Delete() error {

}
