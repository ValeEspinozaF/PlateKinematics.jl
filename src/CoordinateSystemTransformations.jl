"""
	ToDegrees(radValue::Union{Float64, Array})

Convert angles from radians to degrees.
"""
function ToDegrees(radValue::Union{Float64, Array})
	degValue = radValue * (180/pi)
	return degValue
end

"""
	ToRadians(degValue::Union{Float64, Array})

Convert angles from degrees to radians.
"""
function ToRadians(degValue::Union{Float64, Array})
	radValue = degValue * (pi/180)
	return radValue
end


"""
	cart2sph(x::Float64, y::Float64, z::Float64)
	cart2sph(x::Array{N}, y::Array{N}, z::Array{N}) where {N<:Float64}

Transform Cartesian coordinates into Spherical coordinates. 
Both input and outputs are expressed in degrees.
"""
function cart2sph(x::Float64, y::Float64, z::Float64)

	lon_deg = ToDegrees(atan( y, x ))
	lat_deg = ToDegrees(atan( z, (x^2 + y^2)^0.5 ))
	om = (x^2 + y^2 + z^2).^0.5

	return [lon_deg, lat_deg, om]
end

function cart2sph(x::Array{N}, y::Array{N}, z::Array{N}) where {N<:Float64}

	if typeof(x) == typeof(y) == typeof(z)

		lon_deg = ToDegrees(atan.( y, x ))
		lat_deg = ToDegrees(atan.( z, (x.^2 + y.^2).^0.5 ))
		om = (x.^2 + y.^2 + z.^2).^0.5

	else
		error("X,Y,Z input types are not the same (x: $(typeof(x)), y: $(typeof(y)), z: $(typeof(z))).")
	end

	return [lon_deg, lat_deg, om]
end


"""
	sph2cart(lon_deg::Float64, lat_deg::Float64, mag=1::Float64)
	sph2cart(lon_deg::Array{N}, lat_deg::Array{N}, mag::Array{N}) where {N<:Float64}
	sph2cart(lon_deg::Array{N}, lat_deg::Array{N}) where {N<:Float64}

Transform Spherical coordinate(s) into Cartesian coordinate(s). 
Both input and outputs are expressed in degrees. 
"""
function sph2cart(lon_deg::Float64, lat_deg::Float64, mag=1.0::Float64)

	lon_rad = ToRadians(lon_deg)
	lat_rad = ToRadians(lat_deg)

	x = mag * cos(lon_rad) * cos(lat_rad)
	y = mag * cos(lat_rad) * sin(lon_rad)
	z = mag * sin(lat_rad)

	return [x, y, z]
end


function sph2cart(lon_deg::Array{N}, lat_deg::Array{N}, mag::Array{N}) where {N<:Float64}

	if typeof(lon_deg) == typeof(lat_deg) == typeof(mag)

		lon_rad = ToRadians(lon_deg)
		lat_rad = ToRadians(lat_deg)

		x = mag .* cos.(lon_rad) .* cos.(lat_rad)
		y = mag .* cos.(lat_rad) .* sin.(lon_rad)
		z = mag .* sin.(lat_rad)

	else
		error("Arrays are not of the same type (lon_deg: $(typeof(lon_deg)), lat_deg: $(typeof(lat_deg)), mag: $(typeof(mag))).")
	end

	return [x, y, z]
end


function sph2cart(lon_deg::Array{N}, lat_deg::Array{N}) where {N<:Float64}

	if typeof(lon_deg) == typeof(lat_deg)

		lon_rad = ToRadians(lon_deg)
		lat_rad = ToRadians(lat_deg)

		x = cos.(lon_rad) .* cos.(lat_rad)
		y = cos.(lat_rad) .* sin.(lon_rad)
		z = sin.(lat_rad)

	else
		error("Arrays are not of the same type (lon_deg: $(typeof(lon_deg)), lat_deg: $(typeof(lat_deg))).")
	end

	return [x, y, z]
end