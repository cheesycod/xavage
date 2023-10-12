package types

type UserLogin struct {
	Username string `json:"username" description:"The username of the user"`
	Password string `json:"password" description:"The password of the user"`
}