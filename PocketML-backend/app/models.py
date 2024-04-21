from sqlmodel import Field, Relationship, SQLModel


class User(SQLModel):
    username: str = Field(primary_key=True, unique=True, index=True)
    email: str = Field(default="un@defin.ed", unique=True)
    name: str = Field(default="undefined")
    token: str = Field(default="undefined")
    email_notif: bool = Field(default=True)

    is_authenticated: bool = Field(default=False)
    is_admin: bool = Field(default=False)
