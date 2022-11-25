"""
Converts a value/array from [radians] to [degrees]
"""
function ToDegrees(radValue::Union{Number, Vector, Matrix})
	degValue = radValue * (180/pi)
	return degValue
end

"""
Converts a value/array from [degrees] to [radians].
"""
function ToRadians(degValue::Union{Number, Vector, Matrix})
	radValue = degValue * (pi/180)
	return radValue
end


"""
Transforms cartesian xyz vector coordinates into spherical coordinates. 

Output element(s) format is as follows:
[1] longitude (deg East) of the pole.
[2] latitude (deg North) of the pole.
[3] magnitude (vector units of measurement)
"""
function cart2sph(x::Union{Number, Matrix, Vector}, y::Union{Number, Matrix, Vector}, z::Union{Number, Matrix, Vector})

	if typeof(x) != typeof(y) || typeof(y) != typeof(z)
		error("X,Y,Z input types are not the same. Output may have unexpected shape.")
	end

	if size(x) != size(y) || size(y) != size(z)
		error("X,Y,Z input sizes are not the same. Output may have unexpected shape.")
	end

	lon_deg = ToDegrees(atan.( y, x ))
	lat_deg = ToDegrees(atan.( z, (x.^2 + y.^2).^0.5 ))
	om = (x.^2 + y.^2 + z.^2).^0.5

	return lon_deg, lat_deg, om
end


"""
Transforms spherical coordinates [degrees] into cartesian xyz vector(s) coordinates. 
Lon_deg, lat_deg, mag may be Numbers, 1xn Matrices or Vectors.

Output will have the same unit of measurement as "mag" input.
"""
function sph2cart(lon_deg::Union{Number, Matrix, Vector}, lat_deg::Union{Number, Matrix, Vector}, mag=1::Union{Number, Matrix, Vector})

	if typeof(lon_deg) != typeof(lat_deg)
		error("Longitude and latitude input types are not the same. Output may have unexpected shape.")
	end

	if size(lon_deg) != size(lat_deg) 
		error("Longitude and latitude input sizes are not the same. Output may have unexpected shape.")
	end

	lon_rad = ToRadians(lon_deg)
	lat_rad = ToRadians(lat_deg)

	x = mag .* cos.(lon_rad) .* cos.(lat_rad)
	y = mag .* cos.(lat_rad) .* sin.(lon_rad)
	z = mag .* sin.(lat_rad)

	return x, y, z
end