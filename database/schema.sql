-- =========================================================================
-- Script DDL: Esquema de Base de Datos - Sistema de Gestión "CarMotors"
-- Motor: MySQL / MariaDB
-- =========================================================================

DROP DATABASE IF EXISTS carmotors_db;
CREATE DATABASE carmotors_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE carmotors_db;

-- -----------------------------------------------------------------
-- 1. Tablas de Consulta (Catálogos)
-- -----------------------------------------------------------------

CREATE TABLE repuesto_tipos (
                                id INT AUTO_INCREMENT PRIMARY KEY,
                                nombre VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE servicio_estados (
                                  id INT AUTO_INCREMENT PRIMARY KEY,
                                  nombre VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE mantenimiento_tipos (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     nombre VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB;

-- -----------------------------------------------------------------
-- 2. Tablas Operacionales
-- -----------------------------------------------------------------

CREATE TABLE clientes (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          nombre VARCHAR(255) NOT NULL,
                          documento_identidad VARCHAR(20) UNIQUE NOT NULL,
                          telefono VARCHAR(20),
                          correo_electronico VARCHAR(100) UNIQUE NOT NULL
) ENGINE=InnoDB;

CREATE TABLE vehiculos (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           cliente_id INT NOT NULL,
                           placa VARCHAR(10) UNIQUE NOT NULL,
                           marca VARCHAR(50),
                           modelo VARCHAR(50),
                           CONSTRAINT fk_vehiculos_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE proveedores (
                             id INT AUTO_INCREMENT PRIMARY KEY,
                             nombre VARCHAR(255) NOT NULL,
                             contacto VARCHAR(255)
) ENGINE=InnoDB;

CREATE TABLE repuestos (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           nombre VARCHAR(255) NOT NULL,
                           repuesto_tipo_id INT NOT NULL,
                           proveedor_id INT NOT NULL,
                           precio_compra DECIMAL(10, 2) NOT NULL,
                           precio_venta DECIMAL(10, 2) NOT NULL,
                           cantidad_stock INT NOT NULL,
                           stock_minimo INT NOT NULL,
                           CONSTRAINT fk_repuestos_tipo FOREIGN KEY (repuesto_tipo_id) REFERENCES repuesto_tipos(id),
                           CONSTRAINT fk_repuestos_proveedor FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
) ENGINE=InnoDB;

CREATE TABLE servicios (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           vehiculo_id INT NOT NULL,
                           mantenimiento_tipo_id INT NOT NULL,
                           fecha_recepcion DATETIME NOT NULL,
                           fecha_entrega DATETIME,
                           descripcion_problema TEXT,
                           costo_mano_obra DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
                           estado_id INT NOT NULL,
                           CONSTRAINT fk_servicios_vehiculo FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id),
                           CONSTRAINT fk_servicios_mantenimiento FOREIGN KEY (mantenimiento_tipo_id) REFERENCES mantenimiento_tipos(id),
                           CONSTRAINT fk_servicios_estado FOREIGN KEY (estado_id) REFERENCES servicio_estados(id)
) ENGINE=InnoDB;

CREATE TABLE servicios_repuestos (
                                     servicio_id INT,
                                     repuesto_id INT,
                                     cantidad_usada INT NOT NULL,
                                     precio_unitario_venta DECIMAL(10, 2) NOT NULL,
                                     PRIMARY KEY (servicio_id, repuesto_id),
                                     CONSTRAINT fk_serv_rep_servicio FOREIGN KEY (servicio_id) REFERENCES servicios(id) ON DELETE CASCADE,
                                     CONSTRAINT fk_serv_rep_repuesto FOREIGN KEY (repuesto_id) REFERENCES repuestos(id)
) ENGINE=InnoDB;

CREATE TABLE facturas (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          servicio_id INT UNIQUE NOT NULL,
                          fecha_emision DATETIME NOT NULL,
                          total_repuestos DECIMAL(10, 2),
                          total_mano_obra DECIMAL(10, 2),
                          impuestos DECIMAL(10, 2),
                          total_final DECIMAL(10, 2) NOT NULL,
                          CONSTRAINT fk_facturas_servicio FOREIGN KEY (servicio_id) REFERENCES servicios(id) ON DELETE CASCADE
) ENGINE=InnoDB;