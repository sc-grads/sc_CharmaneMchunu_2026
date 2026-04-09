from datetime import datetime
import asyncio
from asyncio import Future
from unittest import result

import requests
import results
from requests import Response

async def check_status(url: str) -> dict[str, int|str]:
    start_time = datetime.now()
    response :Response = await asyncio.to_thread(requests.get,url, None)
    end_time :datetime= datetime.now()

    return {'website': url,
            'status': response.status_code,
            'start_time': f'{start_time%H:%M:%S}',
            'end_time': f'{end_time:%H:%M:%S}'}

async def main()->None:
    print('Fetching results :')

    tasks:Future = asyncio.gather(
        check_status('https://bing.com'),
        check_status('https://indently.com'),
        check_status('https://apple.com'),
        check_status('https://youtube.com'),
        check_status('https://lol.com'),
        return_exceptions=True
    )
    result: list[dict] = await tasks
    print(result)

    for result in results:
        print(result)

if __name__ == '__main__':
    asyncio.run(main=main())



