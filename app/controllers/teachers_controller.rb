require 'json'

class TeachersController < ApplicationController
  def index
    @teachers = Teacher.all
  end

  def new
    @teacher = Teacher.new
    @teacher.fields.build
    @teacher.levels.build
    @fields = Field.all.each_with_object([]) { |field, arr| arr << field["name"] }
    @levels = Level.all.each_with_object([]) { |field, arr| arr << "#{field["grade"]}-#{field["cycle"]}" }
  end

  def create
    params["teacher"]["levels_attributes"].keys.each_with_index do |key, index|
      @field = Field.find_by(name: params["teacher"]["fields_attributes"]["#{key}"]["name"])

      level_elements = params["teacher"]["levels_attributes"]["#{key}"]["cycle"]
      level_elements = level_elements.split('-')
      @level = Level.find_by(grade: level_elements[0], cycle: level_elements[1])

      @teacher = Teacher.find_by(first_name: params["teacher"]["first_name"], last_name: params["teacher"]["last_name"])
      if @teacher.nil?
        @teacher = Teacher.new(teacher_params)
        if @teacher.save
          skill = Skill.new(teacher: @teacher, field: @field, level: @level)
          skill.save
        else
          render :new
          break
        end
      else
        skill = Skill.new(teacher: @teacher, field: @field, level: @level)
        skill.save
      end
      if params["teacher"]["levels_attributes"].keys.length == index + 1
        redirect_to teachers_path
      end
    end
  end

  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy
    redirect_to teachers_path
  end

  private

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name)
  end

end
