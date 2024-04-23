from sqlmodel import Field, Relationship, SQLModel


class User(SQLModel, table=True):
    email: str = Field(default="un@defin.ed", primary_key=True, unique=True, index=True)
    name: str = Field(default="undefined")
    password: str = Field(default="undefined")
    token: str = Field(default="undefined")
    email_notif: bool = Field(default=True)

    is_authenticated: bool = Field(default=False)
    is_admin: bool = Field(default=False)


class CreateUser(SQLModel):
    email: str
    name: str
    password: str
