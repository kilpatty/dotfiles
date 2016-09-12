package objects

import (
	"errors"
	"fmt"
	"sezzle/instantach/db"
	"sezzle/instantach/encryption"
	"sezzle/instantach/notifications"
	"sezzle/instantach/objects"

	"github.com/golang/glog"
	"github.com/jinzhu/gorm"
)

//UserLoginAttempt : Struct user for logging in
type UserLoginAttempt struct {
	gorm.Model

	UserPhone   UserPhone
	UserPhoneID uint

	PIN string `json:"pin"`
}

//Define Authentication Errors
var (
	ErrPhoneRequired    = errors.New("Phone Number Required")
	ErrPinRequired      = errors.New("Pin Required")
	ErrOTPRequired      = errors.New("OTP Required")
	ErrInvalidOTP       = errors.New("Invalid OTP")
	ErrInvalidPhonePin  = errors.New("Invalid Phone and Pin")
	ErrUserDoesNotExist = errors.New("User does not exist")
)

//Try will attempt to login using the credentials provided by the login attempt.
func (ula *UserLoginAttempt) Try() error {
	if ula.UserPhone.Phone.Number == "" {
		return ErrPhoneRequired
	}
	if ula.PIN == "" {
		return ErrPinRequired
	}

	//Now we get the User from the Database right? - From UserPhone User.GetByPhone

	//If no user, return that error.

	//Then we check the UserPin with the pin we have

	//Check the Database where User Phone number = phone,
	user := new(User)
	result := db.DB.Table("users").Select("*").Joins("left join user_phones on user_phones.user_id = users.id").Where("user_phones.user_id = ?", ula.UserPhoneID).Scan(user)
	err := result.Error
	glog.Info(result.RecordNotFound())
	if err != nil {
		glog.Info(err.Error)
		return ErrUserDoesNotExist
	}

	if !encryption.CompareHashAndPassword(user.PIN, ula.PIN) {
		//The pins are incorrect.
	}

	//Send the OTP.
	otp := objects.OTP{}
	otp.CreateOTPandHash() //Change this to official OTP generation formula
	otp.Save()

	//Build our SMS message.
	smsMessage := fmt.Sprintf("%s is your Sezzle authentication code.", otp.OTP)

	sms := notifications.Twilio{
		To:      "+1" + l.UserPhone.Phone.Number,
		Message: smsMessage,
	}

	sms.SendSMS()

	return err

}
