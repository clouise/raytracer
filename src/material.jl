include("./light.jl")

const defaultambient = 0.1
const defaultdiffuse = 0.9
const defaultspecular = 0.9
const defaultshininess = 200.0
const defaultcolor = color(1, 1, 1)

mutable struct Material
    color::vec3
    ambient::Float64
    diffuse::Float64
    specular::Float64
    shininess::Float64
end

Material() = Material(defaultcolor, defaultambient,
                      defaultdiffuse, defaultspecular,
                      defaultshininess)

function lighting(material::Material, light::PointLight,
                  point::svec, eyev::svec, normalv::svec)
    ### Implements the Phong reflection model
    ### https://en.wikipedia.org/wiki/Phong_reflection_model

    # combine the material color with light intensity
    effective_color = material.color .* light.intensity
    # find the direction to the light source
    lightv = normalise(light.position - point)
    # compute the ambient contribution
    ambient = effective_color * material.ambient
    # light_dot_normal represents the cosine between the light vector and the
    # normal vector. a negative number means the light
    # is on the other side of the surface
    light_dot_normal = dot(lightv, normalv)
    if light_dot_normal < 0
        diffuse = color(0, 0, 0)
        specular = color(0, 0, 0)
    else
        diffuse = effective_color * material.diffuse * light_dot_normal
        reflectv = reflect(-1 * lightv, normalv)
        reflect_dot_eye = dot(reflectv, eyev)
        if reflect_dot_eye <= 0
            specular = color(0, 0, 0)
        else
            factor = reflect_dot_eye ^ material.shininess
            specular = light.intensity * material.specular * factor
        end
    end
    return ambient + diffuse + specular
end

