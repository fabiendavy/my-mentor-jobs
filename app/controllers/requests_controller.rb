class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]

  def index
    @requests = Request.all
  end

  def new
    @fields = Field.all.each_with_object([]) { |field, arr| arr << field["name"] }
    @levels = Level.all.each_with_object([]) { |field, arr| arr << "#{field["grade"]}-#{field["cycle"]}" }
    @request = Request.new
  end

  def show
  end

  def create
    @field = Field.find_by(name: params["request"]["field"])

    level_elements = params["request"]["level"]
    level_elements = level_elements.split('-')
    @level = Level.find_by(grade: level_elements[0], cycle: level_elements[1])

    @request = Request.new(request_params)
    @request.field = @field
    @request.level = @level
    
    if @request.save
      export_requests_to_json
      redirect_to edit_request_path(@request)
    else
      render :new
    end
  end

  def edit
    field = @request.field
    level = @request.level

    @matching_teachers = Skill.where(field: field, level: level).collect { |skill| skill.teacher }
  end

  def update
    @request.update_column(:teacher_id, params[:teacher_id])
    export_requests_to_json
    redirect_to request_path(@request)
  end

  def destroy
    @request.destroy
    export_requests_to_json
    redirect_to requests_path
  end
  
  private

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:client_name)
  end

  def export_requests_to_json
    @data = JSON.parse(File.read('datatest.json'))
    @data["requests"] = []
    Request.all.each_with_object([]) do |request|
      if request.teacher
        @data["requests"] << { id: request["id"], client_name: request["client_name"], field: request.field["name"], grade: request.level["grade"], cycle: request.level["cycle"], teacher: "#{request.teacher["first_name"]} #{request.teacher["last_name"]}" }
      else
        @data["requests"] << { id: request["id"], client_name: request["client_name"], field: request.field["name"], grade: request.level["grade"], cycle: request.level["cycle"] }
      end
    end
    File.open('datatest.json', 'wb') { |file| file.write(JSON.generate(@data)) }
  end
end
