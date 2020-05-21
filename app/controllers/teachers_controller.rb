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
    # we iterate over the levels to create a new skill with each field and level
    params["teacher"]["levels_attributes"].keys.each_with_index do |key, index|
      # we look for the corresponding field
      @field = Field.find_by(name: params["teacher"]["fields_attributes"]["#{key}"]["name"])
      
      # we look for the corresponding level
      level_elements = params["teacher"]["levels_attributes"]["#{key}"]["cycle"]
      level_elements = level_elements.split('-')
      @level = Level.find_by(grade: level_elements[0], cycle: level_elements[1])

      # the first iteration, we create a teacher, and for the others we look for the one we just created previously
      @teacher = Teacher.find_by(first_name: params["teacher"]["first_name"], last_name: params["teacher"]["last_name"])

      # we take care to have a field and a level before to save a new teacher, to be sure that we don't save a teacher without skill(s)
      if @field && @level
        if @teacher.nil?
          @teacher = Teacher.new(teacher_params)
          if @teacher.save
            create_new_skill
            export_teachers_to_json
          else
            render :new
            break
          end
        else
          create_new_skill
          export_teachers_to_json
        end
      else
        render :new
        break
      end
      # when the last skill is created we redirect to the teachers index
      redirect_to teachers_path if params["teacher"]["levels_attributes"].keys.length == index + 1
    end
  end

  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy
    redirect_to teachers_path
    export_teachers_to_json
  end

  private

  def teacher_params
    params.require(:teacher).permit(:first_name, :last_name)
  end

  def export_teachers_to_json
    data = JSON.parse(File.read('data.json'))
    data["teachers"] = []
    Teacher.all.each_with_object([]) { |teacher|
      # we create an array of objects for each skill for each teacher
      skills = Skill.where(teacher: teacher).each_with_object([]) { |skill, arr| arr << {
        id: skill[:id],
        field: skill.field["name"], 
        grade: skill.level["grade"], 
        cycle: skill.level["cycle"]
      } }
      
      data["teachers"] << { 
        id: teacher["id"], 
        first_name: teacher["first_name"], 
        last_name: teacher["last_name"], 
        skills: skills
      } 
    }
    File.open('data.json', 'wb') { |file| file.write(JSON.generate(data)) }
  end

  def create_new_skill
    skill = Skill.new(teacher: @teacher, field: @field, level: @level)
    skill.save
  end
end
