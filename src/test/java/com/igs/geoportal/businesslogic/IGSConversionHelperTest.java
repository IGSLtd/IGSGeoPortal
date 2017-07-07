package com.igs.geoportal.businesslogic;

import static org.junit.Assert.*;

import org.apache.log4j.Logger;
import org.junit.Test;

import com.esri.core.geometry.Point;

public class IGSConversionHelperTest {
	
	private Logger logger = Logger.getLogger(IGSConversionHelperTest.class);
	
	
	@Test
	public void testBNGToLongLatConversion() {
		
		IGSConversionHelper instance = new IGSConversionHelper();
		assertNotNull(instance);
		//UTM coordinates, x=129974.284 y=831969.738
		Point p = instance.fromBNGLngLat(new Point(129974.284, 8319690.738));
		assertEquals(57.298205824196216, p.getX(), 10f);
		assertEquals(-6.484327009827164, p.getY(), 10f);
		
		p = instance.fromBNGLngLat(new Point(130055.124, 832077.548));
		assertEquals(57.29921906473863, p.getX(), 10f);
		assertEquals(-6.483107341945565, p.getY(), 10f);
		
		p = instance.fromBNGLngLat(new Point(130055.124, 832077.548));
		assertEquals(57.29921906473863, p.getX(), 10f);
		assertEquals(-6.483107341945565, p.getY(), 10f);
		
		p = instance.fromBNGLngLat(new Point(130064.665, 832072.357));
		assertEquals(57.299178215179325, p.getX(), 10f);
		assertEquals(-6.48294383321017, p.getY(), 10f);
		
		p = instance.fromBNGLngLat(new Point(130076.844, 832064.09));
		assertEquals(57.29911137750404, p.getX(), 10f);
		assertEquals(-6.482733325462281, p.getY(), 10f);
		
		p = instance.fromBNGLngLat(new Point(130670.781, 831616.798));
		assertEquals(57.29545621485383, p.getX(), 10f);
		assertEquals(-6.472420290528703, p.getY(), 10f);
		
		p = instance.fromBNGLngLat(new Point(130682.091, 831607.376));
		assertEquals(57.29537850320389, p.getX(), 15f);
		assertEquals(-6.472222940219103, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(130685.396, 831604.022));
		assertEquals(57.2953504146866, p.getX(), 15f);
		assertEquals(-6.472164616779448, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(130527.948, 831356.553));
		assertEquals(57.293041404354945, p.getX(), 15f);
		assertEquals(-6.474499560107607, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(130515.417, 831361.852));
		assertEquals(57.29921906473863, p.getX(), 15f);
		assertEquals(-6.483107341945565, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(130502.486, 831368.887));
		assertEquals(57.293136844747735, p.getX(), 15f);
		assertEquals(-6.474934163367352, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(130490.307, 831377.154));
		assertEquals(57.29320369625114, p.getX(), 15f);
		assertEquals(-6.475144622880707, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(130019.437, 831731.764));
		assertEquals(57.29610138306647, p.getX(), 15f);
		assertEquals(-6.4833202697465175, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(130023.039, 831745.813));
		assertEquals(57.29622932423922, p.getX(), 15f);
		assertEquals(-6.483276019165427, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(130019.758, 831816.125));
		assertEquals(57.29685704978306, p.getX(), 15f);
		assertEquals(-6.48340704234022, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(129976.227, 831954.438));
		assertEquals(57.298069956846575, p.getX(), 15f);
		assertEquals(-6.484278161620148, p.getY(), 15f);
		
		p = instance.fromBNGLngLat(new Point(129974.284, 831969.738));
		assertEquals(57.298205824196216, p.getX(), 15f);
		assertEquals(-6.484327009827164, p.getY(), 15f);

	}

}
