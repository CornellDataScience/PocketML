from models import SQLModel
from sqlmodel import create_engine
from config import settings

engine = create_engine(url=settings.DATABASE_URL,
                       echo=settings.DEBUG, connect_args=settings.CONNECT_ARGS)


def create_db_and_tables():
    """
    Handles the creation of the database and tables
    """
    SQLModel.metadata.create_all(engine)
