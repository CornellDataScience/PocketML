from sqlmodel import Field, SQLModel


class User(SQLModel, table=True):
    email: str = Field(default="un@defin.ed", primary_key=True, unique=True, index=True)
    name: str = Field(default="undefined")
    token: str = Field(nullable=False)
    email_notif: bool = Field(default=True)

    is_authenticated: bool = Field(default=False)
    is_admin: bool = Field(default=False)


class CreateUser(SQLModel):
    email: str
    name: str
    password: str
    email_notif: bool
