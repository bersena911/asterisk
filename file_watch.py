import os
import subprocess
from time import sleep

from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer


class Handler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.src_path.endswith(".conf"):
            subprocess.run(["asterisk", "-rx", "core restart now"])


def main():
    observer = Observer()
    observer.schedule(Handler(), "/etc/asterisk")  # watch the local directory
    observer.start()

    try:
        while True:
            sleep(1)
    except KeyboardInterrupt:
        observer.stop()

    observer.join()


if __name__ == '__main__':
    if os.environ.get("DEBUG") == "True":
        main()
