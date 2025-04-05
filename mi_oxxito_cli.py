from sqlalchemy import create_engine, text, Connection
from sqlalchemy.exc import IntegrityError
from typing import Tuple
import pandas as pd
import random

USERNAME = 'root'
PASSWORD = 'root'
HOST = 'localhost'
PORT = '3306'
DATABASE = 'mi_oxxito'

def main():
  connection = conect_sql()
  lider_id = login(connection=connection)
  _siguiente_turno(connection=connection, juego_id=1)  # Probando la funcion auxiliar, no funciona.
  while True:
    menu = menu_principal()
    match menu:
      case '1':
        juego_id, jugador_id = crear_juego(connection=connection, lider_id=lider_id)
      case '2':
        jugador_id = registrarse_juego(connection=connection, lider_id=lider_id)
      case '3':
        iniciar_juego(connection=connection, lider_id=lider_id)
      case '4':
        estatus_partidas_activas(connection=connection , lider_id=lider_id)
      case 'E':
        break
      case _:
        print("Opcion Invalida, reintentando...\n\n")


def conect_sql() -> Connection:
  engine = create_engine(f'mysql+pymysql://{USERNAME}:{PASSWORD}@{HOST}:{PORT}/{DATABASE}')

  try:
    connection = engine.connect()
    print("Connected to MySQL successfully!")
    return connection
  except Exception as e:
    print(f"Failed to connect: {e}")


def login(connection: Connection) -> int:
  while True:
    usuario = input("--Login--\nUsuario: ")
    contrasena = input("Contraseña: ")

    credenciales_result = text('SELECT lider_id FROM lideres WHERE usuario = :usuario AND contrasena = :contrasena')
    result = connection.execute(credenciales_result, {'usuario': usuario, 'contrasena': contrasena})
    row = result.fetchone()
    
    if row:
        print('Credenciales correctos, entrado al juego...\n\n')
        return row[0]  # o row.lider_id si usas row mapeado
    else:
        print('Credenciales incorrectos, intenta de nuevo.\n')
  

def menu_principal() -> str:
  while True:
    print('--Menu--')
    print('1. Crear Partida')
    print('2. Unirme a Partida')
    print('3. Iniciar Partida')
    print('4. Estatus Partidas Activas')
    print('5. Jugar Partida')
    print('"E" for exit')
    opcion = input('Opcion: ')
    return opcion
    

def crear_juego(connection: Connection, lider_id: int) -> Tuple[int, int]:  # Crea un Juego e inserta a el creador como jugador.
  meta = int(input('\n\nPuntos meta: '))
  insert_juego_query = text("INSERT INTO juegos (puntos_meta) VALUES (:meta)")
  juego_result = connection.execute(insert_juego_query, {"meta": meta})
  juego_id = juego_result.lastrowid

  insert_jugador = text('insert into jugadores (lider_id, juego_id) values (:lider_id, :juego_id)')
  jugador_result = connection.execute(insert_jugador, {"lider_id": lider_id, "juego_id": juego_id})
  jugador_id = jugador_result.lastrowid

  insert_creador = text('update juegos set creador = :jugador_id where juego_id = 1')
  connection.execute(insert_creador, {"jugador_id": jugador_id, "juego_id": juego_id})

  connection.commit()
  
  print(f"Tu ID de juego es: {juego_id}")
  return juego_id, jugador_id


def registrarse_juego(connection: Connection, lider_id: int) -> int:  # Dado el id de un juego, crea un nuevo jugador para dicho juego.
  juego_id = int(input("\n\nIngresa el ID de juego: "))
  try:
    insert_jugador_query = text('INSERT INTO jugadores (lider_id, juego_id) VALUES (:lider_id, :juego_id)')
    jugador_result = connection.execute(insert_jugador_query, {"lider_id": lider_id, "juego_id": juego_id})
    connection.commit()
    jugador_id = jugador_result.lastrowid
    print("Te has unido al juego correctamente.")
    return jugador_id

  except IntegrityError:
    print("El Id del juego es invalido o ya estás registrado en este juego.")
    connection.rollback()

def iniciar_juego(connection: Connection, lider_id: int):  # Verifica que el creador lo este iniciando, que no este iniciado, asigna turnos y asigna el primer jugador
  juego_id = input('\n\nIngresa el ID del juego que quieres iniciar.\nID: ')
  select_jugador = text('select j.jugador_id from lideres l join jugadores j on j.lider_id = l.lider_id where j.juego_id = :juego_id and l.lider_id = :lider_id')
  jugador_result = connection.execute(select_jugador, {'juego_id': juego_id, 'lider_id': lider_id})
  jugador = jugador_result.first()[0]

  if jugador is None:
    print('No eres parte de este juego.')
    return

  select_juego = text("SELECT creador, jugador_en_turno FROM juegos WHERE juego_id = :juego_id")
  juego_result = connection.execute(select_juego, {'juego_id': juego_id})
  juego_data = juego_result.first()
  
  if not juego_data[0] == jugador:
    print("No puedes iniciar un juego que no fue creado por ti.\n\n")
    return
  if juego_data[1] is not None:
    print("Este juego ya esta en curso.\n\n")
    return

  select_jugadores = text("select jugador_id from jugadores where juego_id = :juego_id")
  jugadores_result = connection.execute(select_jugadores, {'juego_id': juego_id})

  jugador_ids = [row[0] for row in jugadores_result.all()]
  
  orden_numeros = random.sample(range(1,10), len(jugador_ids))
  orden_jugadores = dict(zip(orden_numeros, jugador_ids))


  for turno, jugador_id in orden_jugadores.items():
    update_turnos = text("UPDATE Jugadores SET turno = :turno WHERE jugador_id = :jugador_id")
    connection.execute(update_turnos, {'jugador_id': jugador_id, 'turno': turno})
    connection.commit()

  print('\n\nTurnos Asignados.')

  primer_jugador = orden_jugadores[min(orden_jugadores.keys())]
  update_turno_actual = text("UPDATE Juegos SET jugador_en_turno = :primer_jugador WHERE juego_id = :juego_id")
  connection.execute(update_turno_actual, {'primer_jugador': primer_jugador, 'juego_id': juego_id})
  connection.commit()

  print(f'Primer jugador en turno es ID: {primer_jugador}')

def estatus_partidas_activas(connection: Connection, lider_id: int):
  select_estatus = text("""
  select j2.juego_id, j2.jugador_en_turno, j.jugador_id, j2.creador, j2.ganador
  from lideres l 
  join jugadores j on j.lider_id = l.lider_id
  join juegos j2 on j.juego_id = j2.juego_id 
  where l.lider_id = :lider_id 
  """)
  estatus_df = pd.read_sql(select_estatus, connection, params={'lider_id': lider_id})

  print('\n\n')
  for i, row in estatus_df.iterrows():
    if row['ganador'] is not None:
      pass
    elif row['jugador_en_turno'] == row['jugador_id']:
      print(f'ID: {row['juego_id']}\t¡Es tu turno!')
    elif row['jugador_en_turno'] == row['jugador_id'] and row['jugador_en_turno'] is not None:
      print(f'ID: {row['juego_id']}\tAun no es tu turno')  # Se deberia de poner el id del lider en turno
    elif row['jugador_en_turno'] is None and row['jugador_id'] == row['creador']:
      print(f'ID: {row['juego_id']}\t No has empezado el juego.')
    elif row['jugador_en_turno'] is None and not (row['jugador_id'] == row['creador']):
      print(f'ID: {row['juego_id']}\t El jugador {row['creador']}, no ha empezado el juego.')
    
    
def _siguiente_turno(connection: Connection, juego_id: int): # Funcion auxiliar para cuando se termina de jugar una ronda.
  select_turno = text("SELECT jugador_en_turno FROM juegos WHERE juego_id = :juego_id")
  turno_result = connection.execute(select_turno, {'juego_id': juego_id})
  turno_data = turno_result.first()

  if turno_data is None:
    print("No hay un juego activo con ese ID.")
    return
  if turno_data[0] is None:
    print("El juego no ha empezado.")
    return
  turno_actual = turno_data[0]

  select_jugadores = text("SELECT jugador_id, turno FROM jugadores WHERE juego_id = :juego_id ORDER BY turno ASC")
  jugadores_result = connection.execute(select_jugadores, {'juego_id': juego_id})
  jugadores_data = jugadores_result.all()

  for i, (_, turno) in enumerate(jugadores_data):
    if turno == turno_actual:
      siguiente_idx = i + 1

  siguiente_jugador_id = jugadores_data[siguiente_idx][0]

  update_turno = text("UPDATE juegos SET jugador_en_turno = :siguiente_jugador_id WHERE juego_id = :juego_id")
  connection.execute(update_turno, {'siguiente_jugador_id': siguiente_jugador_id, 'juego_id': juego_id})
  connection.commit()

  print(f'El siguiente jugador en turno es: {siguiente_jugador_id}')
  
  pass
    

if __name__ == "__main__":
  main()
