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
    @course = Course.new
    compute_courses_price
  end

  def create
    # we look for the corresponding field
    @field = Field.find_by(name: params["request"]["field"])

    # we look for the corresponding level
    level_elements = params["request"]["level"]
    level_elements = level_elements.split('-')
    @level = Level.find_by(grade: level_elements[0], cycle: level_elements[1])

    # we create the request with the client_name, price_per_hour and corresponding field & level
    @request = Request.new(request_params)
    @request.field = @field
    @request.level = @level
    
    if @request.save
      export_requests_to_json 
      # we redirect to the edit page to show the collection of matching teachers and let the licent pick up one of them
      redirect_to edit_request_path(@request)
    else
      render :new
    end
  end

  def edit
    @field = @request.field
    @level = @request.level

    # we get all the teachers matching the field and level
    @matching_teachers = Skill.where(field: @field, level: @level).collect { |skill| skill.teacher }
  end

  def update
    if params[:commit] == 'Update Request'  # handle when we update some values of the request with the edit form
      @request.update(request_params)
    else                                    # handle when the client choose a teacher from the collection
      @request.update_column(:teacher_id, params[:teacher_id]) 
    end
    export_requests_to_json
    redirect_to request_path(@request)
  end

  def destroy
    @request.destroy
    export_requests_to_json
    redirect_to requests_path
  end
  
  private

  def compute_courses_price
    @total_price = 0
    @request.courses.each { |course| @total_price += course.length * @request.price_per_hour }
  end

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:client_name, :price_per_hour)
  end

  def export_requests_to_json
    data = JSON.parse(File.read('data.json'))
    data["requests"] = []
    Request.all.each_with_object([]) do |request|
      if request.teacher
        # if the teacher has been chosen we rewrite the request in the json with the teacher
        data["requests"] << { id: request["id"], client_name: request["client_name"], field: request.field["name"], grade: request.level["grade"], cycle: request.level["cycle"], teacher: "#{request.teacher["first_name"]} #{request.teacher["last_name"]}" }
      else
        # we write in the json file without the teacher when the request is just created but the teacher is not yet chosen
        data["requests"] << { id: request["id"], client_name: request["client_name"], field: request.field["name"], grade: request.level["grade"], cycle: request.level["cycle"] }
      end
    end
    File.open('data.json', 'wb') { |file| file.write(JSON.generate(data)) }
  end
end
