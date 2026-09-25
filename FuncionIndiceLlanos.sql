CREATE OR REPLACE FUNCTION public.fn_registrar_acceso_llanos(
    p_id_empleado integer, 
    p_dispositivo varchar
)
RETURNS void AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM public.empleado WHERE id_empleado = p_id_empleado) THEN
        INSERT INTO public.historial_login (dispositivo, empleado_id_empleado) 
        VALUES (p_dispositivo, p_id_empleado);
    ELSE
        RAISE EXCEPTION 'Error de seguridad: El ID de empleado % no existe.', p_id_empleado;
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT public.fn_registrar_acceso_llanos(1, 'Android App - Xiaomi Redmi Note 13');

SELECT id_log, fecha_hora, dispositivo, empleado_id_empleado 
FROM public.historial_login 
ORDER BY id_log DESC;

CREATE INDEX idx_empleado_estado_llanos ON public.empleado (estado);

SELECT id_empleado, correo, estado 
FROM public.empleado 
WHERE correo = 'luis.mendoza@donlucho.com' AND estado = true;
