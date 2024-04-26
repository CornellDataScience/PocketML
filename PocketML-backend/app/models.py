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

class Job(SQLModel, table=True):
    name: str = Field(default="undefined", primary_key=True, unique=True, index=True)
    wandb: bool = Field(default=False)
    wandb_link: str = Field(default="undefined")
    start_time: str = Field(default="undefined")

    current_step: int = Field(default=0)
    current_status: str = Field(default="stopped") # should this be undefined?
    last_update_time: str = Field(default="undefined")

    
class CreateJob(SQLModel):
    name: str
    wandb: bool
    wandb_link: str
    start_time: str