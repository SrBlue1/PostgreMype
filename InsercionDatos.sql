-- SCRIPT DE INSERCIÓN DE DATOS DE PRUEBA COHERENTES (PERÚ)
BEGIN;

-- 1. TABLA: rol (3 registros maestros)
INSERT INTO public.rol (nombre_rol, descripcion) VALUES
('Administrador', 'Acceso total al sistema, configuraciones globales y gestión de sucursales.'),
('Supervisor', 'Gestión operativa de la sucursal asignada, reportes y control de personal.'),
('Cajero', 'Operaciones exclusivas del punto de venta, apertura, facturación y cierre de caja.');

-- 2. TABLA: comerciante (3 empresas peruanas ficticias)
INSERT INTO public.comerciante (ruc, nombre_comcercial, razon_social, telefono) VALUES
('20601234561', 'Minimarket Don Lucho', 'Inversiones Comerciales Lucho S.A.C.', '912345678'),
('20559876542', 'Boutique Mía', 'Corporación Textil Moda del Perú E.I.R.L.', '987654321'),
('20441122333', 'TecnoWilson', 'Importaciones Tecnológicas del Centro S.A.', '944556677');

-- 3. TABLA: configuracion (3 registros - Relación 1:1 estricta con comerciante)
INSERT INTO public.configuracion (moneda, igv_porcentaje, comerciante_id_comerciante) VALUES
('PEN', 18.00, (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20601234561')),
('PEN', 18.00, (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20559876542')),
('USD', 18.00, (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20441122333')); -- Opera en dólares

-- 4. TABLA: suscripcion (3 registros de planes comerciales)
INSERT INTO public.suscripcion (tipo_plan, fecha_inicio, fecha_fin, estado_pago, comerciante_id_comerciante) VALUES
('Plan Emprende Mensual', '2026-09-01', '2026-10-01', 'Activo', (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20601234561')),
('Plan Corporativo Anual', '2026-01-15', '2027-01-15', 'Activo', (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20559876542')),
('Plan Emprende Mensual', '2026-09-10', '2026-10-10', 'Activo', (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20441122333'));

-- 5. TABLA: sucursal (5 locales distribuidos coherentemente)
INSERT INTO public.sucursal (nombre_sucursal, direccion, comerciante_id_comerciante) VALUES
('Don Lucho - Sede Principal Los Olivos', 'Av. Las Palmeras 1420, Los Olivos, Lima', (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20601234561')),
('Don Lucho - Express San Juan', 'Av. Chimú 455, San Juan de Lurigancho, Lima', (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20601234561')),
('Boutique Mía - Real Plaza Salaverry', 'Av. Salaverry 2370, Jesús María, Lima', (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20559876542')),
('Boutique Mía - Jockey Plaza', 'Av. Javier Prado Este 4200, Santiago de Surco, Lima', (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20559876542')),
('TecnoWilson - Principal Cercado', 'Av. Garcilaso de la Vega 1250, Cercado de Lima', (SELECT id_comerciante FROM public.comerciante WHERE ruc = '20441122333'));

-- 6. TABLA: empleado (10 trabajadores con DNI de 8 dígitos distribuidos en las sucursales)
INSERT INTO public.empleado (dni, nombres, apellidos, correo, clave, estado, rol_id_rol, sucursal_id_sucursal) VALUES
('45678901', 'Luis Alberto', 'Mendoza Castro', 'luis.mendoza@donlucho.com', 'hash_secure_password_1', true, 
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Administrador'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'Don Lucho - Sede Principal Los Olivos')),
('71234567', 'Carlos Ivan', 'Gomez Rivas', 'carlos.gomez@donlucho.com', 'hash_secure_password_2', true, 
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Supervisor'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'Don Lucho - Express San Juan')),
('72345678', 'Ana Maria', 'Palacios Quispe', 'ana.palacios@donlucho.com', 'hash_secure_password_3', true, 
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Cajero'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'Don Lucho - Sede Principal Los Olivos')),
('73456789', 'Pedro Jose', 'Huaman Ortiz', 'pedro.huaman@donlucho.com', 'hash_secure_password_4', true, 
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Cajero'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'Don Lucho - Express San Juan')),
('40112233', 'Milagros Elena', 'Salazar Paz', 'm.salazar@boutiquemia.pe', 'hash_secure_password_5', true, 
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Administrador'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'Boutique Mía - Real Plaza Salaverry')),
('41223344', 'Sofia Belen', 'Díaz Torres', 's.diaz@boutiquemia.pe', 'hash_secure_password_6', true, 
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Supervisor'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'Boutique Mía - Jockey Plaza')),
('42334455', 'Jorge Luis', 'Guerrero Flores', 'j.guerrero@boutiquemia.pe', 'hash_secure_password_7', true, 
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Cajero'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'Boutique Mía - Real Plaza Salaverry')),
('43445566', 'Elena Maria', 'Benites Soto', 'e.benites@boutiquemia.pe', 'hash_secure_password_8', false, -- Empleado inactivo
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Cajero'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'Boutique Mía - Jockey Plaza')),
('46556677', 'Ricardo Alfonzo', 'Vargas Luna', 'rvargas@tecnowilson.com', 'hash_secure_password_9', true, 
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Administrador'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'TecnoWilson - Principal Cercado')),
('47667788', 'Christian David', 'Zegarra Rios', 'czegarra@tecnowilson.com', 'hash_secure_password_10', true, 
  (SELECT id_rol FROM public.rol WHERE nombre_rol = 'Cajero'), (SELECT id_sucursal FROM public.sucursal WHERE nombre_sucursal = 'TecnoWilson - Principal Cercado'));

-- 7. TABLA: historial_login (10 registros de auditoría de conexiones)
INSERT INTO public.historial_login (fecha_hora, dispositivo, empleado_id_empleado) VALUES
('2026-09-19 08:00:23', 'Windows 11 - Chrome V120', (SELECT id_empleado FROM public.empleado WHERE dni = '45678901')),
('2026-09-19 08:15:10', 'Android 14 - App Mobile', (SELECT id_empleado FROM public.empleado WHERE dni = '71234567')),
('2026-09-19 08:30:00', 'Windows 10 - Edge V119', (SELECT id_empleado FROM public.empleado WHERE dni = '72345678')),
('2026-09-19 08:45:12', 'Windows 11 - Chrome V120', (SELECT id_empleado FROM public.empleado WHERE dni = '73456789')),
('2026-09-19 09:00:05', 'macOS Sonoma - Safari V17', (SELECT id_empleado FROM public.empleado WHERE dni = '40112233')),
('2026-09-19 09:05:44', 'iOS 17 - App Mobile', (SELECT id_empleado FROM public.empleado WHERE dni = '41223344')),
('2026-09-19 09:15:30', 'Windows 10 - Chrome V120', (SELECT id_empleado FROM public.empleado WHERE dni = '42334455')),
('2026-09-19 09:30:18', 'Windows 11 - Firefox V121', (SELECT id_empleado FROM public.empleado WHERE dni = '46556677')),
('2026-09-19 09:45:00', 'Windows 11 - Chrome V120', (SELECT id_empleado FROM public.empleado WHERE dni = '47667788')),
('2026-09-19 14:22:15', 'Windows 11 - Chrome V120', (SELECT id_empleado FROM public.empleado WHERE dni = '45678901')); -- Re-conexión del administrador

COMMIT;
