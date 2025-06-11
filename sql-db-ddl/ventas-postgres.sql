-- DDL para PostgreSQL 16: “Sistema Integral de Ventas – Comercial El Éxito Plus”
-- 3ª Forma Normal, surrogate keys INT, auditoría (created_at, updated_at, deleted_at)
-- Triggers para mantener updated_at

-- 0. Eliminar todo con CASCADE
DROP TABLE IF EXISTS
  venta_pago, linea_venta, venta, entrega, pago_metodo,
  devolucion, garantia, cupon, promo_producto, promocion,
  movimiento, stock, combo_producto, combo,
  producto_categoria, categoria, producto_imagen, producto_especificacion, producto,
  modelo, marca,
  cliente_direccion, cliente_contacto, fidelizacion, cliente,
  sucursal, empleado_sucursal, empleado, carrier,
  estado_envio, estado_garantia, estado_prod_devolucion, accion_devolucion, promocion_tipo,
  pago_tipo, estado_laboral, empleado_rol, estado_venta, canal_venta, nivel_fidelizacion, tipo_cliente
CASCADE;

-- 1. Función genérica para actualizar updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 2. Lookup tables (dominios)
CREATE TABLE tipo_cliente (
  id_tipo              SERIAL PRIMARY KEY,
  codigo               CHAR(1)     UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_tipo_cliente_upd BEFORE UPDATE ON tipo_cliente
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE nivel_fidelizacion (
  id_nivel             SERIAL PRIMARY KEY,
  codigo               CHAR(1)     UNIQUE NOT NULL,
  descripcion          VARCHAR(20) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_nivel_fidelizacion_upd BEFORE UPDATE ON nivel_fidelizacion
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE canal_venta (
  id_canal             SERIAL PRIMARY KEY,
  codigo               CHAR(1)     UNIQUE NOT NULL,
  descripcion          VARCHAR(20) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_canal_venta_upd BEFORE UPDATE ON canal_venta
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE estado_venta (
  id_estado            SERIAL PRIMARY KEY,
  codigo               VARCHAR(20) UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_estado_venta_upd BEFORE UPDATE ON estado_venta
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE empleado_rol (
  id_rol               SERIAL PRIMARY KEY,
  codigo               VARCHAR(30) UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_empleado_rol_upd BEFORE UPDATE ON empleado_rol
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE estado_laboral (
  id_estado_lab        SERIAL PRIMARY KEY,
  codigo               VARCHAR(20) UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_estado_laboral_upd BEFORE UPDATE ON estado_laboral
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE pago_tipo (
  id_pago_tipo         SERIAL PRIMARY KEY,
  codigo               VARCHAR(20) UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_pago_tipo_upd BEFORE UPDATE ON pago_tipo
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE promocion_tipo (
  id_prom_tipo         SERIAL PRIMARY KEY,
  codigo               VARCHAR(30) UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_promocion_tipo_upd BEFORE UPDATE ON promocion_tipo
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE accion_devolucion (
  id_accion            SERIAL PRIMARY KEY,
  codigo               VARCHAR(20) UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_accion_devolucion_upd BEFORE UPDATE ON accion_devolucion
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE estado_prod_devolucion (
  id_est_prod          SERIAL PRIMARY KEY,
  codigo               VARCHAR(20) UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_estado_prod_devolucion_upd BEFORE UPDATE ON estado_prod_devolucion
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE estado_garantia (
  id_est_gar           SERIAL PRIMARY KEY,
  codigo               VARCHAR(20) UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_estado_garantia_upd BEFORE UPDATE ON estado_garantia
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE estado_envio (
  id_est_env           SERIAL PRIMARY KEY,
  codigo               VARCHAR(20) UNIQUE NOT NULL,
  descripcion          VARCHAR(50) NOT NULL,
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_estado_envio_upd BEFORE UPDATE ON estado_envio
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 3. Transportistas
CREATE TABLE carrier (
  id_carrier           SERIAL PRIMARY KEY,
  nombre               VARCHAR(100) NOT NULL,
  contacto             VARCHAR(100),
  telefono             VARCHAR(20),
  email                VARCHAR(100),
  website              VARCHAR(150),
  created_at           TIMESTAMP    NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP    NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_carrier_upd BEFORE UPDATE ON carrier
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 4. Marca y Modelo
CREATE TABLE marca (
  id_marca             SERIAL PRIMARY KEY,
  nombre               VARCHAR(50)  UNIQUE NOT NULL,
  created_at           TIMESTAMP    NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP    NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_marca_upd BEFORE UPDATE ON marca
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE modelo (
  id_modelo            SERIAL PRIMARY KEY,
  nombre               VARCHAR(50) NOT NULL,
  id_marca             INT         NOT NULL REFERENCES marca(id_marca),
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_modelo_upd BEFORE UPDATE ON modelo
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 5. Producto y multivaluados
CREATE TABLE producto (
  id_producto          SERIAL PRIMARY KEY,
  sku                  CHAR(10)     UNIQUE NOT NULL,
  id_modelo            INT           NOT NULL REFERENCES modelo(id_modelo),
  nombre               VARCHAR(100)  NOT NULL,
  descripcion          TEXT,
  precio_base          DECIMAL(10,2) NOT NULL,
  porcentaje_impuesto  DECIMAL(5,2)  NOT NULL,
  created_at           TIMESTAMP      NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP      NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_producto_upd BEFORE UPDATE ON producto
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE producto_especificacion (
  id_espec             SERIAL PRIMARY KEY,
  id_producto          INT NOT NULL REFERENCES producto(id_producto),
  especificacion       VARCHAR(200) NOT NULL,
  created_at           TIMESTAMP     NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP     NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_producto_especificacion_upd BEFORE UPDATE ON producto_especificacion
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE producto_imagen (
  id_imagen            SERIAL PRIMARY KEY,
  id_producto          INT NOT NULL REFERENCES producto(id_producto),
  url_imagen           VARCHAR(255) NOT NULL,
  created_at           TIMESTAMP     NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP     NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_producto_imagen_upd BEFORE UPDATE ON producto_imagen
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 6. Categorías y Combos
CREATE TABLE categoria (
  id_categoria         SERIAL PRIMARY KEY,
  nombre               VARCHAR(50) NOT NULL,
  descripcion          TEXT,
  id_padre             INT REFERENCES categoria(id_categoria),
  created_at           TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_categoria_upd BEFORE UPDATE ON categoria
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE producto_categoria (
  id_pc                SERIAL PRIMARY KEY,
  id_producto          INT NOT NULL REFERENCES producto(id_producto),
  id_categoria         INT NOT NULL REFERENCES categoria(id_categoria),
  created_at           TIMESTAMP NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_producto_categoria_upd BEFORE UPDATE ON producto_categoria
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE combo (
  id_combo             SERIAL PRIMARY KEY,
  nombre               VARCHAR(100) NOT NULL,
  descripcion          TEXT,
  precio_total         DECIMAL(10,2) NOT NULL,
  created_at           TIMESTAMP     NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP     NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_combo_upd BEFORE UPDATE ON combo
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE combo_producto (
  id_cp                SERIAL PRIMARY KEY,
  id_combo             INT NOT NULL REFERENCES combo(id_combo),
  id_producto          INT NOT NULL REFERENCES producto(id_producto),
  cantidad             INT NOT NULL,
  created_at           TIMESTAMP NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_combo_producto_upd BEFORE UPDATE ON combo_producto
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 7. Empleado y asignaciones
CREATE TABLE empleado (
  id_empleado          SERIAL PRIMARY KEY,
  cedula               VARCHAR(20) UNIQUE NOT NULL,
  nombre               VARCHAR(100) NOT NULL,
  id_rol               INT NOT NULL REFERENCES empleado_rol(id_rol),
  fecha_ingreso        DATE NOT NULL,
  id_estado_lab        INT NOT NULL REFERENCES estado_laboral(id_estado_lab),
  created_at           TIMESTAMP NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_empleado_upd BEFORE UPDATE ON empleado
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE empleado_sucursal (
  id_es               SERIAL PRIMARY KEY,
  id_empleado         INT NOT NULL REFERENCES empleado(id_empleado),
  id_sucursal         INT NOT NULL,  -- FK adelante
  fecha_asign         DATE NOT NULL,
  rol_en_sucursal     VARCHAR(30),
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_empleado_sucursal_upd BEFORE UPDATE ON empleado_sucursal
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 8. Sucursal, Stock y Movimiento
CREATE TABLE sucursal (
  id_sucursal         SERIAL PRIMARY KEY,
  nombre               VARCHAR(100) NOT NULL,
  ciudad               VARCHAR(50),
  direccion            VARCHAR(150),
  latitud              DECIMAL(9,6),
  longitud             DECIMAL(9,6),
  id_empleado_gerente  INT REFERENCES empleado(id_empleado),
  created_at            TIMESTAMP    NOT NULL DEFAULT now(),
  updated_at            TIMESTAMP    NOT NULL DEFAULT now(),
  deleted_at            TIMESTAMP
);
CREATE TRIGGER trg_sucursal_upd BEFORE UPDATE ON sucursal
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

ALTER TABLE empleado_sucursal
  ADD CONSTRAINT fk_es_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal);

CREATE TABLE stock (
  id_stock            SERIAL PRIMARY KEY,
  id_producto         INT NOT NULL REFERENCES producto(id_producto),
  id_sucursal         INT NOT NULL REFERENCES sucursal(id_sucursal),
  cantidad            INT NOT NULL DEFAULT 0,
  fecha_registro      DATE NOT NULL,
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_stock_upd BEFORE UPDATE ON stock
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE movimiento (
  id_mov              SERIAL PRIMARY KEY,
  id_sucursal_origen  INT NOT NULL REFERENCES sucursal(id_sucursal),
  id_sucursal_destino INT NOT NULL REFERENCES sucursal(id_sucursal),
  fecha               DATE NOT NULL,
  cantidad            INT NOT NULL,
  motivo              TEXT,
  id_empleado_resp    INT NOT NULL REFERENCES empleado(id_empleado),
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_movimiento_upd BEFORE UPDATE ON movimiento
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 9. Cliente y subentidades
CREATE TABLE cliente (
  id_cliente           SERIAL PRIMARY KEY,
  documento            VARCHAR(20) UNIQUE NOT NULL,
  nombre               VARCHAR(100) NOT NULL,
  id_tipo_cliente      INT NOT NULL REFERENCES tipo_cliente(id_tipo),
  email                VARCHAR(100),
  telefono             VARCHAR(20),
  created_at           TIMESTAMP NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_cliente_upd BEFORE UPDATE ON cliente
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE fidelizacion (
  id_fidel             SERIAL PRIMARY KEY,
  id_cliente           INT NOT NULL REFERENCES cliente(id_cliente),
  puntos_acumulados    INT NOT NULL DEFAULT 0,
  id_nivel             INT NOT NULL REFERENCES nivel_fidelizacion(id_nivel),
  created_at           TIMESTAMP NOT NULL DEFAULT now(),
  updated_at           TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at           TIMESTAMP
);
CREATE TRIGGER trg_fidelizacion_upd BEFORE UPDATE ON fidelizacion
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE cliente_contacto (
  id_contacto         SERIAL PRIMARY KEY,
  id_cliente          INT NOT NULL REFERENCES cliente(id_cliente),
  nombre_contacto     VARCHAR(100) NOT NULL,
  email               VARCHAR(100),
  telefono            VARCHAR(20),
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_cliente_contacto_upd BEFORE UPDATE ON cliente_contacto
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE cliente_direccion (
  id_direccion        SERIAL PRIMARY KEY,
  id_cliente          INT NOT NULL REFERENCES cliente(id_cliente),
  calle               VARCHAR(150),
  ciudad              VARCHAR(50),
  provincia           VARCHAR(50),
  pais                VARCHAR(50),
  latitud             DECIMAL(9,6),
  longitud            DECIMAL(9,6),
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_cliente_direccion_upd BEFORE UPDATE ON cliente_direccion
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 10. Venta, LíneaVenta y Pagos
CREATE TABLE venta (
  id_venta            SERIAL PRIMARY KEY,
  nro_factura         CHAR(15) UNIQUE NOT NULL,
  fecha_venta         TIMESTAMP NOT NULL,
  total               DECIMAL(12,2) NOT NULL,
  id_estado_venta     INT NOT NULL REFERENCES estado_venta(id_estado),
  id_canal_venta      INT NOT NULL REFERENCES canal_venta(id_canal),
  id_cliente          INT NOT NULL REFERENCES cliente(id_cliente),
  id_empleado         INT NOT NULL REFERENCES empleado(id_empleado),
  id_empleado_auth    INT REFERENCES empleado(id_empleado),
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_venta_upd BEFORE UPDATE ON venta
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE linea_venta (
  id_linea            SERIAL PRIMARY KEY,
  id_venta            INT NOT NULL REFERENCES venta(id_venta),
  id_producto         INT NOT NULL REFERENCES producto(id_producto),
  cantidad            INT NOT NULL,
  precio_unitario     DECIMAL(10,2) NOT NULL,
  descuento_aplicado  DECIMAL(5,2) NOT NULL DEFAULT 0,
  impuesto_aplicado   DECIMAL(5,2) NOT NULL DEFAULT 0,
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_linea_venta_upd BEFORE UPDATE ON linea_venta
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE pago_metodo (
  id_pago_met         SERIAL PRIMARY KEY,
  id_pago_tipo        INT NOT NULL REFERENCES pago_tipo(id_pago_tipo),
  detalles            TEXT,
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_pago_metodo_upd BEFORE UPDATE ON pago_metodo
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE venta_pago (
  id_vp               SERIAL PRIMARY KEY,
  id_venta            INT NOT NULL REFERENCES venta(id_venta),
  id_pago_met         INT NOT NULL REFERENCES pago_metodo(id_pago_met),
  monto               DECIMAL(12,2) NOT NULL,
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_venta_pago_upd BEFORE UPDATE ON venta_pago
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 11. Entregas
CREATE TABLE entrega (
  id_entrega          SERIAL PRIMARY KEY,
  id_venta            INT NOT NULL REFERENCES venta(id_venta),
  fecha_envio         DATE NOT NULL,
  id_carrier          INT NOT NULL REFERENCES carrier(id_carrier),
  costo               DECIMAL(10,2),
  id_estado_envio     INT NOT NULL REFERENCES estado_envio(id_est_env),
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_entrega_upd BEFORE UPDATE ON entrega
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 12. Promociones y Cupones
CREATE TABLE promocion (
  id_promocion        SERIAL PRIMARY KEY,
  nombre              VARCHAR(100) NOT NULL,
  id_prom_tipo        INT NOT NULL REFERENCES promocion_tipo(id_prom_tipo),
  fecha_inicio        DATE NOT NULL,
  fecha_fin           DATE,
  condiciones         TEXT,
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_promocion_upd BEFORE UPDATE ON promocion
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE promo_producto (
  id_pp               SERIAL PRIMARY KEY,
  id_promocion        INT NOT NULL REFERENCES promocion(id_promocion),
  id_producto         INT NOT NULL REFERENCES producto(id_producto),
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_promo_producto_upd BEFORE UPDATE ON promo_producto
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE cupon (
  id_cupon            SERIAL PRIMARY KEY,
  codigo              VARCHAR(50) UNIQUE NOT NULL,
  fecha_emision       DATE NOT NULL,
  fecha_venc          DATE,
  id_promocion        INT NOT NULL REFERENCES promocion(id_promocion),
  id_cliente          INT NOT NULL REFERENCES cliente(id_cliente),
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_cupon_upd BEFORE UPDATE ON cupon
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

-- 13. Devoluciones y Garantías
CREATE TABLE devolucion (
  id_devolucion       SERIAL PRIMARY KEY,
  id_venta            INT NOT NULL REFERENCES venta(id_venta),
  fecha               DATE NOT NULL,
  motivo              TEXT,
  id_est_prod_dev     INT NOT NULL REFERENCES estado_prod_devolucion(id_est_prod),
  id_accion           INT NOT NULL REFERENCES accion_devolucion(id_accion),
  created_at          TIMESTAMP NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_devolucion_upd BEFORE UPDATE ON devolucion
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();

CREATE TABLE garantia (
  id_garantia         SERIAL PRIMARY KEY,
  numero_serie        VARCHAR(50) NOT NULL,
  fecha_activacion    DATE        NOT NULL,
  vigencia_meses      INT         NOT NULL,
  id_venta            INT NOT NULL REFERENCES venta(id_venta),
  id_est_gar          INT NOT NULL REFERENCES estado_garantia(id_est_gar),
  created_at          TIMESTAMP   NOT NULL DEFAULT now(),
  updated_at          TIMESTAMP   NOT NULL DEFAULT now(),
  deleted_at          TIMESTAMP
);
CREATE TRIGGER trg_garantia_upd BEFORE UPDATE ON garantia
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
