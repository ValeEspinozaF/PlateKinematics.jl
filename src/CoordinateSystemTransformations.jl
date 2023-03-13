"""
	ToDegrees(radValue::Union{Number, Array})

Convert angles from radians to degrees.
"""
function ToDegrees(radValue::Union{Number, Array})
	degValue = radValue * (180/pi)
	return degValue
end

"""
	ToRadians(degValue::Union{Number, Array})

Convert angles from degrees to radians.
"""
function ToRadians(degValue::Union{Number, Array})
	radValue = degValue * (pi/180)
	return radValue
end


"""
	cart2sph(x::Number, y::Number, z::Number)
	cart2sph(x::Array{T}, y::Array{T}, z::Array{T}) where {T<:Number}

Transform Cartesian coordinates into Spherical coordinates. 
Both input and outputs are expressed in degrees.
"""
function cart2sph(x::Number, y::Number, z::Number)

	lon_deg = ToDegrees(atan( y, x ))
	lat_deg = ToDegrees(atan( z, (x^2 + y^2)^0.5 ))
	om = (x^2 + y^2 + z^2).^0.5

	return [lon_deg, lat_deg, om]
end

function cart2sph(x::Array{T}, y::Array{T}, z::Array{T}) where {T<:Number}

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
	sph2cart(lon_deg::Number, lat_deg::Number, mag=1::Number)
	sph2cart(lon_deg::Array{T}, lat_deg::Array{T}, mag::Array{T}) where {T<:Number}
	sph2cart(lon_deg::Array{T}, lat_deg::Array{T}) where {T<:Number}

Transform Spherical coordinate(s) into Cartesian coordinate(s). 
Both input and outputs are expressed in degrees. 
"""
function sph2cart(lon_deg::Number, lat_deg::Number, mag=1::Number)

	lon_rad = ToRadians(lon_deg)
	lat_rad = ToRadians(lat_deg)

	x = mag * cos(lon_rad) * cos(lat_rad)
	y = mag * cos(lat_rad) * sin(lon_rad)
	z = mag * sin(lat_rad)

	return [x, y, z]
end


function sph2cart(lon_deg::Array{T}, lat_deg::Array{T}, mag::Array{T}) where {T<:Number}

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


function sph2cart(lon_deg::Array{T}, lat_deg::Array{T}) where {T<:Number}

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