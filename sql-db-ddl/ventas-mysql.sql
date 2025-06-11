-- Desactivar comprobación de llaves foráneas
SET FOREIGN_KEY_CHECKS = 0;

-- 0. Eliminar tablas existentes
DROP TABLE IF EXISTS
  venta_pago, linea_venta, venta, entrega, pago_metodo,
  devolucion, garantia, cupon, promo_producto, promocion,
  movimiento, stock, combo_producto, combo,
  producto_categoria, categoria, producto_imagen, producto_especificacion, producto,
  modelo, marca,
  cliente_direccion, cliente_contacto, fidelizacion, cliente,
  empleado_sucursal, empleado, sucursal,
  carrier,
  estado_envio, estado_garantia, estado_prod_devolucion, accion_devolucion, promocion_tipo,
  pago_tipo, estado_laboral, empleado_rol, estado_venta, canal_venta, nivel_fidelizacion, tipo_cliente;

-- 1. Tablas de dominio
CREATE TABLE tipo_cliente (
  id_tipo       INT AUTO_INCREMENT PRIMARY KEY,
  codigo        CHAR(1)     UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE nivel_fidelizacion (
  id_nivel      INT AUTO_INCREMENT PRIMARY KEY,
  nivel_code    CHAR(1)     UNIQUE NOT NULL,
  descripcion   VARCHAR(20) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE canal_venta (
  id_canal      INT AUTO_INCREMENT PRIMARY KEY,
  codigo        CHAR(1)     UNIQUE NOT NULL,
  descripcion   VARCHAR(20) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE estado_venta (
  id_estado     INT AUTO_INCREMENT PRIMARY KEY,
  codigo        VARCHAR(20) UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE empleado_rol (
  id_rol        INT AUTO_INCREMENT PRIMARY KEY,
  codigo        VARCHAR(30) UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE estado_laboral (
  id_lab        INT AUTO_INCREMENT PRIMARY KEY,
  codigo        VARCHAR(20) UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pago_tipo (
  id_pago_tipo  INT AUTO_INCREMENT PRIMARY KEY,
  codigo        VARCHAR(20) UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE promocion_tipo (
  id_prom_tipo  INT AUTO_INCREMENT PRIMARY KEY,
  codigo        VARCHAR(30) UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE accion_devolucion (
  id_accion     INT AUTO_INCREMENT PRIMARY KEY,
  codigo        VARCHAR(20) UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE estado_prod_devolucion (
  id_est_prod   INT AUTO_INCREMENT PRIMARY KEY,
  codigo        VARCHAR(20) UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE estado_garantia (
  id_est_gar    INT AUTO_INCREMENT PRIMARY KEY,
  codigo        VARCHAR(20) UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE estado_envio (
  id_est_env    INT AUTO_INCREMENT PRIMARY KEY,
  codigo        VARCHAR(20) UNIQUE NOT NULL,
  descripcion   VARCHAR(50) NOT NULL,
  created_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE carrier (
  id_carrier    INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(100) NOT NULL,
  contacto      VARCHAR(100),
  telefono      VARCHAR(20),
  email         VARCHAR(100),
  website       VARCHAR(150),
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME     NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Marca y Modelo
CREATE TABLE marca (
  id_marca      INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(50)  UNIQUE NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME     NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE modelo (
  id_modelo     INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(50)  NOT NULL,
  id_marca      INT          NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME     NULL,
  FOREIGN KEY (id_marca) REFERENCES marca(id_marca)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Producto y multivaluados
CREATE TABLE producto (
  id_producto           INT AUTO_INCREMENT PRIMARY KEY,
  sku                   CHAR(10)     UNIQUE NOT NULL,
  id_modelo             INT           NOT NULL,
  nombre                VARCHAR(100)  NOT NULL,
  descripcion           TEXT,
  precio_base           DECIMAL(10,2) NOT NULL,
  porcentaje_impuesto   DECIMAL(5,2)  NOT NULL,
  created_at            DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at            DATETIME      NULL,
  FOREIGN KEY (id_modelo) REFERENCES modelo(id_modelo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE producto_especificacion (
  id_espec             INT AUTO_INCREMENT PRIMARY KEY,
  id_producto          INT NOT NULL,
  especificacion       VARCHAR(200) NOT NULL,
  created_at           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at           DATETIME     NULL,
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE producto_imagen (
  id_imagen           INT AUTO_INCREMENT PRIMARY KEY,
  id_producto         INT NOT NULL,
  url_imagen          VARCHAR(255) NOT NULL,
  created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at          DATETIME     NULL,
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Categorías y Combos
CREATE TABLE categoria (
  id_categoria     INT AUTO_INCREMENT PRIMARY KEY,
  nombre           VARCHAR(50)  NOT NULL,
  descripcion      TEXT,
  id_padre         INT           NULL,
  created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at       DATETIME      NULL,
  FOREIGN KEY (id_padre) REFERENCES categoria(id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE producto_categoria (
  id_pc             INT AUTO_INCREMENT PRIMARY KEY,
  id_producto       INT NOT NULL,
  id_categoria      INT NOT NULL,
  created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at        DATETIME NULL,
  FOREIGN KEY (id_producto)  REFERENCES producto(id_producto),
  FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE combo (
  id_combo      INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(100) NOT NULL,
  descripcion   TEXT,
  precio_total  DECIMAL(10,2) NOT NULL,
  created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at    DATETIME     NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE combo_producto (
  id_cp            INT AUTO_INCREMENT PRIMARY KEY,
  id_combo         INT NOT NULL,
  id_producto      INT NOT NULL,
  cantidad         INT NOT NULL,
  created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at       DATETIME NULL,
  FOREIGN KEY (id_combo)    REFERENCES combo(id_combo),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Sucursales, Stock y Movimientos
CREATE TABLE sucursal (
  id_sucursal           INT AUTO_INCREMENT PRIMARY KEY,
  nombre                VARCHAR(100) NOT NULL,
  ciudad                VARCHAR(50),
  direccion             VARCHAR(150),
  latitud               DECIMAL(9,6),
  longitud              DECIMAL(9,6),
  id_empleado_gerente   INT,  
  created_at            DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at            DATETIME     NULL,
  FOREIGN KEY (id_empleado_gerente) REFERENCES empleado(id_empleado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE stock (
  id_stock       INT AUTO_INCREMENT PRIMARY KEY,
  id_producto    INT NOT NULL,
  id_sucursal    INT NOT NULL,
  cantidad       INT NOT NULL DEFAULT 0,
  fecha_registro DATE NOT NULL,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at     DATETIME NULL,
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE movimiento (
  id_mov               INT AUTO_INCREMENT PRIMARY KEY,
  id_sucursal_origen   INT NOT NULL,
  id_sucursal_destino  INT NOT NULL,
  fecha                DATE NOT NULL,
  cantidad             INT NOT NULL,
  motivo               TEXT,
  id_empleado_resp     INT NOT NULL,
  created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at           DATETIME NULL,
  FOREIGN KEY (id_sucursal_origen)  REFERENCES sucursal(id_sucursal),
  FOREIGN KEY (id_sucursal_destino) REFERENCES sucursal(id_sucursal),
  FOREIGN KEY (id_empleado_resp)     REFERENCES empleado(id_empleado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Cliente y subentidades
CREATE TABLE cliente (
  id_cliente          INT AUTO_INCREMENT PRIMARY KEY,
  documento           VARCHAR(20)     UNIQUE NOT NULL,
  nombre              VARCHAR(100)    NOT NULL,
  id_tipo_cliente     INT             NOT NULL,
  email               VARCHAR(100),
  telefono            VARCHAR(20),
  created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at          DATETIME        NULL,
  FOREIGN KEY (id_tipo_cliente) REFERENCES tipo_cliente(id_tipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE fidelizacion (
  id_fidel            INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente          INT NOT NULL,
  puntos_acumulados   INT NOT NULL DEFAULT 0,
  id_nivel            INT NOT NULL,
  created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at          DATETIME NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
  FOREIGN KEY (id_nivel)   REFERENCES nivel_fidelizacion(id_nivel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cliente_contacto (
  id_contacto         INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente          INT NOT NULL,
  nombre_contacto     VARCHAR(100) NOT NULL,
  email               VARCHAR(100),
  telefono            VARCHAR(20),
  created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at          DATETIME NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cliente_direccion (
  id_direccion        INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente          INT NOT NULL,
  calle               VARCHAR(150),
  ciudad              VARCHAR(50),
  provincia           VARCHAR(50),
  pais                VARCHAR(50),
  latitud             DECIMAL(9,6),
  longitud            DECIMAL(9,6),
  created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at          DATETIME NULL,
  FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Empleado y asignaciones
CREATE TABLE empleado (
  id_empleado      INT AUTO_INCREMENT PRIMARY KEY,
  cedula           VARCHAR(20)     UNIQUE NOT NULL,
  nombre           VARCHAR(100)    NOT NULL,
  id_rol           INT             NOT NULL,
  fecha_ingreso    DATE            NOT NULL,
  id_estado_lab    INT             NOT NULL,
  created_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at       DATETIME        NULL,
  FOREIGN KEY (id_rol)           REFERENCES empleado_rol(id_rol),
  FOREIGN KEY (id_estado_lab)    REFERENCES estado_laboral(id_lab)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE empleado_sucursal (
  id_es           INT AUTO_INCREMENT PRIMARY KEY,
  id_empleado     INT NOT NULL,
  id_sucursal     INT NOT NULL,
  fecha_asign     DATE NOT NULL,
  rol_en_sucursal VARCHAR(30),
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at      DATETIME NULL,
  FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
  FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Venta, LíneaVenta y Pagos
CREATE TABLE venta (
  id_venta           INT AUTO_INCREMENT PRIMARY KEY,
  nro_factura        CHAR(15)        UNIQUE NOT NULL,
  fecha_venta        DATETIME        NOT NULL,
  total              DECIMAL(12,2)   NOT NULL,
  id_estado_venta    INT             NOT NULL,
  id_canal_venta     INT             NOT NULL,
  id_cliente         INT             NOT NULL,
  id_empleado        INT             NOT NULL,
  id_empleado_auth   INT             NULL,
  created_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at         DATETIME        NULL,
  FOREIGN KEY (id_estado_venta)   REFERENCES estado_venta(id_estado),
  FOREIGN KEY (id_canal_venta)    REFERENCES canal_venta(id_canal),
  FOREIGN KEY (id_cliente)        REFERENCES cliente(id_cliente),
  FOREIGN KEY (id_empleado)       REFERENCES empleado(id_empleado),
  FOREIGN KEY (id_empleado_auth)  REFERENCES empleado(id_empleado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE linea_venta (
  id_linea           INT AUTO_INCREMENT PRIMARY KEY,
  id_venta           INT NOT NULL,
  id_producto        INT NOT NULL,
  cantidad           INT NOT NULL,
  precio_unitario    DECIMAL(10,2) NOT NULL,
  descuento_aplicado DECIMAL(5,2)  NOT NULL DEFAULT 0,
  impuesto_aplicado  DECIMAL(5,2)  NOT NULL DEFAULT 0,
  created_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at         DATETIME NULL,
  FOREIGN KEY (id_venta)    REFERENCES venta(id_venta),
  FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pago_metodo (
  id_pago_met    INT AUTO_INCREMENT PRIMARY KEY,
  id_pago_tipo   INT NOT NULL,
  detalles       TEXT,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at     DATETIME NULL,
  FOREIGN KEY (id_pago_tipo) REFERENCES pago_tipo(id_pago_tipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE venta_pago (
  id_vp          INT AUTO_INCREMENT PRIMARY KEY,
  id_venta       INT NOT NULL,
  id_pago_met    INT NOT NULL,
  monto          DECIMAL(12,2) NOT NULL,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at     DATETIME NULL,
  FOREIGN KEY (id_venta)    REFERENCES venta(id_venta),
  FOREIGN KEY (id_pago_met) REFERENCES pago_metodo(id_pago_met)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. Entregas
CREATE TABLE entrega (
  id_entrega      INT AUTO_INCREMENT PRIMARY KEY,
  id_venta        INT NOT NULL,
  fecha_envio     DATE NOT NULL,
  id_carrier      INT NOT NULL,
  costo           DECIMAL(10,2),
  id_estado_envio INT NOT NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at      DATETIME NULL,
  FOREIGN KEY (id_venta)       REFERENCES venta(id_venta),
  FOREIGN KEY (id_carrier)     REFERENCES carrier(id_carrier),
  FOREIGN KEY (id_estado_envio) REFERENCES estado_envio(id_est_env)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. Promociones y Cupones
CREATE TABLE promocion (
  id_promocion    INT AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL,
  id_prom_tipo    INT NOT NULL,
  fecha_inicio    DATE NOT NULL,
  fecha_fin       DATE,
  condiciones     TEXT,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at      DATETIME NULL,
  FOREIGN KEY (id_prom_tipo) REFERENCES promocion_tipo(id_prom_tipo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE promo_producto (
  id_pp           INT AUTO_INCREMENT PRIMARY KEY,
  id_promocion    INT NOT NULL,
  id_producto     INT NOT NULL,
  created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at      DATETIME NULL,
  FOREIGN KEY (id_promocion) REFERENCES promocion(id_promocion),
  FOREIGN KEY (id_producto)  REFERENCES producto(id_producto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cupon (
  id_cupon         INT AUTO_INCREMENT PRIMARY KEY,
  codigo           VARCHAR(50)   UNIQUE NOT NULL,
  fecha_emision    DATE          NOT NULL,
  fecha_venc       DATE,
  id_promocion     INT NOT NULL,
  id_cliente       INT NOT NULL,
  created_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at       DATETIME      NULL,
  FOREIGN KEY (id_promocion) REFERENCES promocion(id_promocion),
  FOREIGN KEY (id_cliente)    REFERENCES cliente(id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. Devoluciones y Garantías
CREATE TABLE devolucion (
  id_devolucion    INT AUTO_INCREMENT PRIMARY KEY,
  id_venta         INT NOT NULL,
  fecha            DATE NOT NULL,
  motivo           TEXT,
  id_est_prod_dev  INT NOT NULL,
  id_accion        INT NOT NULL,
  created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at       DATETIME NULL,
  FOREIGN KEY (id_venta)        REFERENCES venta(id_venta),
  FOREIGN KEY (id_est_prod_dev) REFERENCES estado_prod_devolucion(id_est_prod),
  FOREIGN KEY (id_accion)       REFERENCES accion_devolucion(id_accion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE garantia (
  id_garantia      INT AUTO_INCREMENT PRIMARY KEY,
  numero_serie     VARCHAR(50) NOT NULL,
  fecha_activacion DATE        NOT NULL,
  vigencia_meses   INT         NOT NULL,
  id_venta         INT         NOT NULL,
  id_est_gar       INT         NOT NULL,
  created_at       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  deleted_at       DATETIME    NULL,
  FOREIGN KEY (id_venta)   REFERENCES venta(id_venta),
  FOREIGN KEY (id_est_gar) REFERENCES estado_garantia(id_est_gar)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Reactivar comprobación de llaves foráneas
SET FOREIGN_KEY_CHECKS = 1;
