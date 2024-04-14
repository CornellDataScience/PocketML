from fastapi import HTTPException


def failure_response(data, code):
    return HTTPException(
        status_code=code,
        detail=data,
    )
