from dataclasses import dataclass,field
from uuid import uuid4, UUID
@dataclass

class Note:
    id: UUID= field(init=False)
    title:str
    body:str

    def __post_init__(self)->None:
        self.id = uuid4()


class NoteApp:
    def __init__(self,author:str ,notes:list[Note]| None= None )->None:
        self.author = author

        if notes is None:
            self.notes = []
        else:
            self.notes = notes

        self.display_instructions()

    @staticmethod
    def display_instructions()->None:
        print('Welcome to Notes!')
        print('Here are the commands: ')
        print('1. Add a note')
        print('2. Edit notes')
        print('3. Delete note')
        print('4. Display notes')

    def _add_note(self)->None:
        title : str= input('Title:')
        body: str= input('Body:')

        note: Note = Note(title=title,body=body)
        self.notes.append(note)
        print('Note added!')

    def _delete_note(self)->None:
        print('Which note would you like to delete?')
        self._show_notes()

        try:
            note_index : int= int(input('Note index:'))-1
            del self.notes[note_index]
            print('Note deleted!')
        except IndexError:
            print('Please select a valid note index....')
            self._delete_note()
        except ValueError:
            print('Please enter a valid index')
            print('Aborting')

    def _show_notes(self)->None:
        if not self._notes:
            print('No notes added!')
            return
        for i, note in enumerate(self._notes, start=1):
            print(f'{i}. {note.title}: {note.body}')

    def _select_option(self,user_input:str)->None:
        if user_input not in ['1','2','3','4'] :
            print('Please select a valid option')
            self._add_note()

        if user_input == '1':
            self._add_note()
        elif user_input == '2':
            self._edit_note()
        elif user_input == '3':
            self._delete_note()
        elif user_input == '4':
            self._show_notes()
    def run_app(self)->None:
        while True:
            user_input: str = input('You :')
            self._select_option(user_input)


def main()->None:
    sample_notes: list[Note] = [Note(title='Title1', body='Hello there, Bob!'),
                                Note(title='Title2', body='More text!')]

    note_app: NoteApp = NoteApp(author='',notes=sample_notes)
    note_app.run_app()

if __name__ == '__main__':
    main()