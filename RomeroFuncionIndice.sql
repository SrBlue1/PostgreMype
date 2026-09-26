
BEGIN;

CREATE OR REPLACE FUNCTION public.fn_obtener_igv_comerciante(
    p_id_comerciante INTEGER
)
RETURNS NUMERIC(4,2)
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    c_igv_contingencia CONSTANT NUMERIC(4,2) := 18.00;
    v_igv NUMERIC(4,2);
BEGIN
    IF p_id_comerciante IS NULL THEN
        RETURN c_igv_contingencia;
    END IF;

    SELECT igv_porcentaje
    INTO v_igv
    FROM public.configuracion
    WHERE comerciante_id_comerciante = p_id_comerciante;

    
    IF NOT FOUND OR v_igv IS NULL THEN
        RETURN c_igv_contingencia;
    END IF;

    RETURN v_igv;
END;
$$;

COMMIT;

SELECT id_comerciante, razon_social, ruc FROM public.comerciante WHERE ruc = '20559876542';
CREATE UNIQUE INDEX IF NOT EXISTS idx_comerciante_ruc ON public.comerciante (ruc);
SELECT public.fn_obtener_igv_comerciante(1);

