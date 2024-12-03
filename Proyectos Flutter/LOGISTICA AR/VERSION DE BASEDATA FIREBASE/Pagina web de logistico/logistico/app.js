firebase.initializeApp({
  apiKey: "AIzaSyCqYH69V4GeIl-dczol4BLQ6RagQA4mspU",
  authDomain: "logistica-ar.firebaseapp.com",
  projectId: "logistica-ar",
  storageBucket: "logistica-ar.appspot.com",
  messagingSenderId: "691963050021",
  appId: "1:691963050021:web:76df98e712a7ef2a4767cc",
  measurementId: "G-7QYE1NFSKD"
});

const db = firebase.firestore();

var tablaIncoming = document.getElementById("tablaIncoming");
var tablaInspeccion = document.getElementById("tablaInspeccion");
var tablaLiberacion = document.getElementById("tablaLiberacion");
var tablaPreEmbarque = document.getElementById("tablaPreEmbarque");

var tbody = document.getElementById("tbodyDatos");
var tbodyInspeccion = document.getElementById("tbodyDatosInspeccion");
var tbodyLiberacion = document.getElementById("tbodyDatosLiberacion");
var tbodyPreEmbarque = document.getElementById("tbodyDatosPreEmbarque");
var totalRegistrosSpan = document.getElementById("totalRegistros");

var currentCollectionRef = db.collection("Incoming"); // Establece la referencia inicial
var currentSection = 'incoming'; // Establece la sección inicial

// Obtén los datos iniciales de "Incoming"
currentCollectionRef.orderBy("fecha", "asc").onSnapshot((querySnapshot) => {
  var datos = [];
  querySnapshot.forEach((doc) => {
    var data = doc.data();
    data.id = doc.id;
    datos.push(data);
  });

  // Llama a la función para inicializar la tabla solo si estás en la sección "Incoming"
  if (currentSection === 'incoming') {
    actualizarTabla(datos);
  }
});

// Obtén los datos iniciales de "Proceso de Inspeccion"
var inspeccionRef = db.collection("Proceso de Inspeccion");
inspeccionRef.orderBy("fecha", "asc").onSnapshot((querySnapshot) => {
  var inspeccionDatos = [];
  querySnapshot.forEach((doc) => {
    var data = doc.data();
    data.id = doc.id;
    inspeccionDatos.push(data);
  });

  // Llama a la función para inicializar la tabla solo si estás en la sección "Proceso de Inspeccion"
  if (currentSection === 'inspeccion') {
    actualizarTabla(inspeccionDatos);
  }
});

var liberacionRef = db.collection("Proceso de Liberacion");
liberacionRef.orderBy("fecha", "asc").onSnapshot((querySnapshot) => {
  var liberacionDatos = [];
  querySnapshot.forEach((doc) => {
    var data = doc.data();
    data.id = doc.id;
    liberacionDatos.push(data);
  });

  // Llama a la función para inicializar la tabla solo si estás en la sección "Proceso de Liberación"
  if (currentSection === 'liberacion') {
    actualizarTabla(liberacionDatos);
  }
});

var preEmbarqueRef = db.collection("Embarque");
preEmbarqueRef.orderBy("fecha", "asc").onSnapshot((querySnapshot) => {
  var preEmbarqueDatos = [];
  querySnapshot.forEach((doc) => {
    var data = doc.data();
    data.id = doc.id;
    preEmbarqueDatos.push(data);
  });

  // Llama a la función para inicializar la tabla solo si estás en la sección "Proceso de Pre-Embarque"
  if (currentSection === 'Pre-embarque') {
    actualizarTabla(preEmbarqueDatos);
  }
});

function cambiarTabla(opcion) {

  var nuevaRef;
  var faseElement = document.getElementById("fase");

  // Oculta todas las tablas
  tablaIncoming.style.display = "none";
  tablaInspeccion.style.display = "none";
  tablaLiberacion.style.display = "none";
  tablaPreEmbarque.style.display = "none";

  // Oculta más tablas según sea necesario
  console.log(opcion);
  switch (opcion) {
    case 'inspeccion':
      faseElement.textContent = 'Proceso de Inspección';
      nuevaRef = db.collection("Proceso de Inspeccion");
      tablaInspeccion.style.display = "block"; // Muestra la tabla de inspección
      break;
    case 'liberacion':
      faseElement.textContent = 'Proceso de Liberación';
      nuevaRef = db.collection("Proceso de Liberacion");
      tablaLiberacion.style.display = "block"; // Muestra la tabla de liberación
      break;
    case 'Pre-Embarque':
      faseElement.textContent = 'Proceso de Pre-Embarque';
      nuevaRef = db.collection("Embarque");
      tablaPreEmbarque.style.display = "block"; // Muestra la tabla de liberación
      break;
    default:
      faseElement.textContent = 'Incoming';
      nuevaRef = db.collection("Incoming");
      tablaIncoming.style.display = "block"; // Muestra la tabla de incoming
  }

  // No detener la escucha si estás en la sección "Proceso de Inspeccion"
  if (currentSection !== 'inspeccion') {
    currentCollectionRef.onSnapshot(() => { }); // Detiene la escucha
  }

  nuevaRef.orderBy("fecha", "asc").onSnapshot((querySnapshot) => {
    var nuevosDatos = [];
    querySnapshot.forEach((doc) => {
      var data = doc.data();
      data.id = doc.id;
      nuevosDatos.push(data);
    });

    nuevosDatos.reverse();


    // Llama a la función para actualizar la tabla solo si estás en la sección correspondiente
    if (currentSection === opcion) {
      if (opcion === 'inspeccion') {
        actualizarTablaInspeccion(nuevosDatos);
      } else if (opcion === 'liberacion') {
        actualizarTablaLiberacion(nuevosDatos);
      } else if (opcion === 'Pre-Embarque') {
        actualizarTablaPreEmbarque(nuevosDatos);
      } else {
        actualizarTabla(nuevosDatos);
      }
    }
  });

  // Actualiza la referencia y la sección actual
  currentCollectionRef = nuevaRef;
  currentSection = opcion;
}

async function actualizarTabla(datos) {
  eliminarModalesAnteriores();
  eliminarBotonesAnteriores();

  var contenedorBoton = document.getElementById("contenedorBoton");

  // Crea el botón
  var botonBuscar = document.createElement("button");
  botonBuscar.className = "btn btn-outline-secondary";
  botonBuscar.type = "button";
  botonBuscar.textContent = "Buscar";
  botonBuscar.addEventListener("click", buscarPorNumeroSerie);

  // Agrega el botón al contenedor
  contenedorBoton.appendChild(botonBuscar);



  tbody.innerHTML = "";

  await datos.forEach((data) => {
    var fila = document.createElement("tr");

    console.log(data);

    fila.innerHTML = `
    
      <td style="font-size: 15px;">${data.fecha}</td>
      <td style="font-size: 15px;">${data.usuario}</td>
      <td style="font-size: 15px;">${data.numSerie}</td>
      <td style="font-size: 15px;"> ${data.proveedor}</td>
      <td style="font-size: 15px;">${data.stl}</td>
      <td style="font-size: 15px;">${data.equipos}</td>
      <td style="font-size: 15px;">${data.descripcion}</td>
      <td style="font-size: 15px;">
        <button type="button" class="btn btn-primary" style="background-color: #ffb71b; color: black;" data-toggle="modal" data-target="#imagenModal${data.id}">
          Ver Imágenes
        </button>
      </td>`;

    tbody.appendChild(fila);

    var modal = document.createElement("div");
    modal.id = `imagenModal${data.id}`;
    modal.classList.add("modal", "fade");
    modal.innerHTML = `
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Imágenes</h5>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <div class="modal-body" id="modalBody${data.id}"></div>
        </div>
      </div>
    `;

    document.body.appendChild(modal);

    var modalBody = document.getElementById(`modalBody${data.id}`);
    data.imagenes.forEach(function (imagenUrl) {
      var enlaceElement = document.createElement("a");
      enlaceElement.href = imagenUrl;
      enlaceElement.target = "_blank";
      enlaceElement.textContent = "Ver Imagen";
      enlaceElement.style.display = "block";
      modalBody.appendChild(enlaceElement);
    });
  });

  totalRegistrosSpan.textContent = datos.length;
}

async function actualizarTablaInspeccion(datos) {
  eliminarModalesAnteriores();
  eliminarBotonesAnteriores();

  var contenedorBoton = document.getElementById("contenedorBoton");

  // Crea el botón
  var botonBuscar = document.createElement("button");
  botonBuscar.className = "btn btn-outline-secondary";
  botonBuscar.type = "button";
  botonBuscar.textContent = "Buscar";
  botonBuscar.addEventListener("click", buscarPorNumeroSerieIns);

  // Agrega el botón al contenedor
  contenedorBoton.appendChild(botonBuscar);

  tbodyInspeccion.innerHTML = "";

  await datos.forEach((data) => {
    var fila = document.createElement("tr");



    fila.innerHTML = `
    
    <td style="font-size: 15px;">${data.fecha}</td>
    <td style="font-size: 15px;">${data.usuario}</td>
    <td style="font-size: 15px;">${data.numSerie}</td>
    <td style="font-size: 15px;"> ${data.equipos}</td>
    <td style="font-size: 15px;">${data.accesorio}</td>
    <td style="font-size: 15px;">${data.numRevision}</td>
    <td style="font-size: 15px;">${data.responsable}</td>
    <td style="font-size: 15px;">${data.parteAfectada}</td>
    <td style="font-size: 15px;">${data.problema}</td>
    <td style="font-size: 15px;">${data.clasificacionDefecto}</td>
    <td style="font-size: 15px;">${data.tipoDefectivo}</td>
    <td style="font-size: 15px;">${data.clasificacionDefectivo}</td>
    <td style="font-size: 15px;">${data.descripcion}</td>
    <td style="font-size: 15px;">${data.desviacion}</td>
    <td style="font-size: 15px;">${data.folioDesviacion}</td>
      <td style="font-size: 15px;">
        <button type="button" class="btn btn-primary" style="background-color: #ffb71b; color: black;" data-toggle="modal" data-target="#imagenModal${data.id}">
          Ver Imágenes
        </button>
      </td>`;

    tbodyInspeccion.appendChild(fila);

    var modal = document.createElement("div");
    modal.id = `imagenModal${data.id}`;
    modal.classList.add("modal", "fade");
    modal.innerHTML = `
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Imágenes</h5>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <div class="modal-body" id="modalBody${data.id}"></div>
        </div>
      </div>
    `;

    document.body.appendChild(modal);

    var modalBody = document.getElementById(`modalBody${data.id}`);
    data.imagenes.forEach(function (imagenUrl) {
      var enlaceElement = document.createElement("a");
      enlaceElement.href = imagenUrl;
      enlaceElement.target = "_blank";
      enlaceElement.textContent = "Ver Imagen";
      enlaceElement.style.display = "block";
      modalBody.appendChild(enlaceElement);
    });
  });

  totalRegistrosSpan.textContent = datos.length;

}


async function actualizarTablaLiberacion(datos) {
  eliminarModalesAnteriores();
  eliminarBotonesAnteriores();

  var contenedorBoton = document.getElementById("contenedorBoton");

  // Crea el botón
  var botonBuscar = document.createElement("button");
  botonBuscar.className = "btn btn-outline-secondary";
  botonBuscar.type = "button";
  botonBuscar.textContent = "Buscar";
  botonBuscar.addEventListener("click", buscarPorNumeroSerieLib);

  // Agrega el botón al contenedor
  contenedorBoton.appendChild(botonBuscar);


  tbodyLiberacion.innerHTML = "";

  await datos.forEach((data) => {
    var fila = document.createElement("tr");

    fila.innerHTML = `
    
   
    <td style="font-size: 15px;">${data.fecha}</td>
    <td style="font-size: 15px;">${data.usuario}</td>
    <td style="font-size: 15px;">${data.numSerie}</td>
    <td style="font-size: 15px;"> ${data.equipos}</td>
    <td style="font-size: 15px;">${data.accesorio}</td>
    <td style="font-size: 15px;">${data.responsable}</td>
    <td style="font-size: 15px;">${data.estacion}</td>
    <td style="font-size: 15px;">${data.descripcion}</td>
    <td style="font-size: 15px;">${data.desviacion}</td>
    <td style="font-size: 15px;">${data.folioDesviacion}</td>
      <td style="font-size: 15px;">
        <button type="button" class="btn btn-primary" style="background-color: #ffb71b; color: black;" data-toggle="modal" data-target="#imagenModal${data.id}">
          Ver Imágenes
        </button>
      </td>`;

    tbodyLiberacion.appendChild(fila);

    var modal = document.createElement("div");
    modal.id = `imagenModal${data.id}`;
    modal.classList.add("modal", "fade");
    modal.innerHTML = `
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Imágenes</h5>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <div class="modal-body" id="modalBody${data.id}"></div>
        </div>
      </div>
    `;

    document.body.appendChild(modal);

    var modalBody = document.getElementById(`modalBody${data.id}`);
    data.imagenes.forEach(function (imagenUrl) {
      var enlaceElement = document.createElement("a");
      enlaceElement.href = imagenUrl;
      enlaceElement.target = "_blank";
      enlaceElement.textContent = "Ver Imagen";
      enlaceElement.style.display = "block";
      modalBody.appendChild(enlaceElement);
    });
  });

  totalRegistrosSpan.textContent = datos.length;

}

async function actualizarTablaPreEmbarque(datos) {
  eliminarModalesAnteriores();
  eliminarBotonesAnteriores();

  var contenedorBoton = document.getElementById("contenedorBoton");

  // Crea el botón
  var botonBuscar = document.createElement("button");
  botonBuscar.className = "btn btn-outline-secondary";
  botonBuscar.type = "button";
  botonBuscar.textContent = "Buscar";
  botonBuscar.addEventListener("click", buscarPorNumeroSeriePre);

  // Agrega el botón al contenedor
  contenedorBoton.appendChild(botonBuscar);

  tbodyPreEmbarque.innerHTML = "";

  await datos.forEach((data) => {
    var fila = document.createElement("tr");

    fila.innerHTML = `
    
   
    <td style="font-size: 15px;">${data.fecha}</td>
    <td style="font-size: 15px;">${data.usuario}</td>
    <td style="font-size: 15px;">${data.cliente}</td>
    <td style="font-size: 15px;">${data.numPedido}</td>
    <td style="font-size: 15px;"> ${data.numSerie}</td>
    <td style="font-size: 15px;">${data.numSerieAsignado}</td>
    <td style="font-size: 15px;">${data.equipos}</td>
    <td style="font-size: 15px;">${data.accesorio}</td>
    <td style="font-size: 15px;">${data.desviacion}</td>
      <td style="font-size: 15px;">
        <button type="button" class="btn btn-primary" style="background-color: #ffb71b; color: black;" data-toggle="modal" data-target="#imagenModal${data.id}">
          Ver Imágenes
        </button>
      </td>`;

    tbodyPreEmbarque.appendChild(fila);

    var modal = document.createElement("div");
    modal.id = `imagenModal${data.id}`;
    modal.classList.add("modal", "fade");
    modal.innerHTML = `
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Imágenes</h5>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <div class="modal-body" id="modalBody${data.id}"></div>
        </div>
      </div>
    `;

    document.body.appendChild(modal);

    var modalBody = document.getElementById(`modalBody${data.id}`);
    data.imagenes.forEach(function (imagenUrl) {
      var enlaceElement = document.createElement("a");
      enlaceElement.href = imagenUrl;
      enlaceElement.target = "_blank";
      enlaceElement.textContent = "Ver Imagen";
      enlaceElement.style.display = "block";
      modalBody.appendChild(enlaceElement);
    });
  });

  totalRegistrosSpan.textContent = datos.length;

}



function eliminarModalesAnteriores() {
  var modalesAnteriores = document.querySelectorAll('.modal');
  modalesAnteriores.forEach((modal) => {
    modal.parentNode.removeChild(modal);
  });
}

function eliminarBotonesAnteriores() {
  var botonesAnteriores = document.querySelectorAll('.btn');
  botonesAnteriores.forEach((boton) => {
    boton.parentNode.removeChild(boton);
  });
}

function buscarPorNumeroSerie() {
  var input, filter, table, tr, td, i, txtValue;
  input = document.getElementById("buscarNumeroSerie");
  filter = input.value.toUpperCase();
  table = document.getElementById("datosTabla"); // Obtén la tabla actualmente visible
  tr = table.getElementsByTagName("tr");

  // Recorre todas las filas de la tabla y oculta aquellas que no coincidan con la búsqueda
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[2]; // Suponiendo que el número de serie está en la tercera columna (índice 2)
    if (td) {
      txtValue = td.textContent || td.innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }
  }
}

function buscarPorNumeroSerieIns() {
  var input, filter, table, tr, td, i, txtValue;
  input = document.getElementById("buscarNumeroSerie");
  filter = input.value.toUpperCase();
  table = document.getElementById("datosTablaInspeccion"); // Obtén la tabla actualmente visible
  tr = table.getElementsByTagName("tr");

  // Recorre todas las filas de la tabla y oculta aquellas que no coincidan con la búsqueda
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[2]; // Suponiendo que el número de serie está en la tercera columna (índice 2)
    if (td) {
      txtValue = td.textContent || td.innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }
  }
}

function buscarPorNumeroSerieLib() {
  var input, filter, table, tr, td, i, txtValue;
  input = document.getElementById("buscarNumeroSerie");
  filter = input.value.toUpperCase();
  table = document.getElementById("datosTablaLiberacion"); // Obtén la tabla actualmente visible
  tr = table.getElementsByTagName("tr");

  // Recorre todas las filas de la tabla y oculta aquellas que no coincidan con la búsqueda
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[2]; // Suponiendo que el número de serie está en la tercera columna (índice 2)
    if (td) {
      txtValue = td.textContent || td.innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }
  }
}

function buscarPorNumeroSeriePre() {
  var input, filter, table, tr, td, i, txtValue;
  input = document.getElementById("buscarNumeroSerie");
  filter = input.value.toUpperCase();
  table = document.getElementById("datosTablaPreEmbarque"); // Obtén la tabla actualmente visible
  tr = table.getElementsByTagName("tr");

  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td")[3]; 
    if (td) {
      txtValue = td.textContent || td.innerText;
      if (txtValue.toUpperCase().indexOf(filter) > -1) {
        tr[i].style.display = "";
      } else {
        tr[i].style.display = "none";
      }
    }
  }
}




  