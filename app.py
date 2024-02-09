from flask import Flask, render_template, redirect, url_for, request
import sqlite3

app = Flask(__name__)

# Ruta principal que muestra el conteo de visitas
@app.route('/')
def index():
    # Conexión a la base de datos
    conn = sqlite3.connect('visitas.db')
    cursor = conn.cursor()

    # Crear la tabla si no existe
    cursor.execute('''CREATE TABLE IF NOT EXISTS contador (
                        id INTEGER PRIMARY KEY,
                        count INTEGER
                     )''')

    # Obtener el conteo actual y actualizarlo
    cursor.execute('SELECT count FROM contador WHERE id = 1')
    count = cursor.fetchone()
    if count:
        count = count[0]
        cursor.execute('UPDATE contador SET count = ? WHERE id = 1', (count + 1,))
    else:
        cursor.execute('INSERT INTO contador (id, count) VALUES (1, 1)')
        count = 1

    conn.commit()
    conn.close()

    return render_template('index.html', count=count)

# Ruta para restablecer el contador

@app.route('/reset', methods=['GET', 'POST']) 
def reset_counter():
    if request.method == 'POST':
        conn = sqlite3.connect('visitas.db')
        cursor = conn.cursor()

        # Establece el contador a cero
        cursor.execute('UPDATE contador SET count = 0 WHERE id = 1')
        conn.commit()
        conn.close()

        # Redirecciona al usuario a la página principal
        return redirect(url_for('index'))

    return render_template('reset.html')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=7070)

