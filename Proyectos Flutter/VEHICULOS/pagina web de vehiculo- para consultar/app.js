
firebase.initializeApp({
    apiKey: "AIzaSyBQZM5nSY7CshCE-Zc3eaUQ8pxv5MswdA0",
    authDomain: "vehiculos-ar.firebaseapp.com",
    databaseURL: "https://vehiculos-ar-default-rtdb.firebaseio.com",
    projectId: "vehiculos-ar",
    storageBucket: "vehiculos-ar.appspot.com",
    messagingSenderId: "743911311320",
    appId: "1:743911311320:web:06c5feda45a9fba18154ad",
    measurementId: "G-VX6G5NB913"
});

const db = firebase.firestore();

// Obtén la referencia de la colección en Firestore
var datosRef = db.collection("Vehiculos");

// Obtén la tabla y el cuerpo de la tabla
var tabla = document.getElementById("datosTabla");
var tbody = document.getElementById("tbodyDatos");

// Obtén la referencia de la colección en Firestore
var datosRef = db.collection("Vehiculos");

// Usa onSnapshot para escuchar cambios en tiempo real y ordenar por horaInicio
datosRef.orderBy("horaInicio", "asc").get().then((querySnapshot) => {
  // Borra el contenido actual de la tabla
  tbody.innerHTML = "";

  querySnapshot.forEach((doc) => {
    // Accede a los datos del documento
    var data = doc.data();

    // Crea una fila para la tabla
    var fila = document.createElement("tr");

    // Agrega celdas con los datos correspondientes
    fila.innerHTML = `
      <td style="font-size: 15px;">${data.vehiculos}</td>
      <td style="font-size: 15px;">${data.horaInicio}</td>
      <td style="font-size: 15px;">${data.nivelGasolina}</td>
      <td style="font-size: 15px;"> ${data.nivelAgua}</td>
      <td style="font-size: 15px;">${data.liquidoFrenos}</td>
      <td style="font-size: 15px;">${data.kilometraje}</td>
      <td style="font-size: 15px;">${data.aceiteMotor}</td>
    `;

    // Agrega la fila al cuerpo de la tabla
    tbody.appendChild(fila);
  });

  // Aplica DataTables con paginación a la tabla
  $(document).ready(function () {
    $('#datosTabla').DataTable({
      "paging": true,  // Habilita la paginación
      "pageLength": 20  // Número de registros por página
    });
  });
});

