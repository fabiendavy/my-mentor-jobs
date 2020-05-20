const addSkill = () => {
  const addSkillBtn = document.getElementById('add-skill-btn');
  const skillsDiv = document.getElementById('skills');
  const fieldsDiv = document.querySelector('.teacher_fields_name');
  const levelsDiv = document.querySelector('.teacher_levels_cycle');
  
  if (addSkillBtn) {
    let counter = 1;
  
    const createOption = (name, divToAppend) => {
      const option = document.createElement("option")
      option.text = `${name}`
      option.value = `${name}`
      divToAppend.add(option)
    };
  
    addSkillBtn.addEventListener('click', (e) => {
      e.preventDefault();
      const selectField = document.createElement("SELECT");
      const selectLevel = document.createElement("SELECT");

      createOption('', selectField);
      createOption('mathematics', selectField);
      createOption('english', selectField);
      createOption('history', selectField);
      createOption('biology', selectField);
      createOption('physics', selectField);

      createOption('', selectLevel);
      createOption('6th-middle', selectLevel);
      createOption('7th-middle', selectLevel);
      createOption('8th-middle', selectLevel);
      createOption('9th-high', selectLevel);
      createOption('10th-high', selectLevel);
      createOption('11th-high', selectLevel);
      createOption('12th-high', selectLevel);

      selectField.setAttribute('class', "form-control selectField optional");
      selectField.setAttribute('name', `teacher[fields_attributes][${counter}][name]`);
      selectField.setAttribute('id', `teacher_fields_attributes_${counter}_name`);
      
      selectLevel.setAttribute('class', "form-control selectField optional");
      selectLevel.setAttribute('name', `teacher[levels_attributes][${counter}][cycle]`);
      selectLevel.setAttribute('id',`teacher_levels_attributes_${counter}_cycle`);

      const labelField = document.createElement("LABEL");
      const labelLevel = document.createElement("LABEL");

      labelField.innerText = 'Name'
      labelField.setAttribute('class', 'select optional mt-3');
      labelField.setAttribute('for', `teacher_fields_attributes_${counter}_name`);

      labelLevel.innerText = 'Level'
      labelLevel.setAttribute('class', 'select optional mt-3');
      labelLevel.setAttribute('for', `teacher_levels_attributes_${counter}_cycle`);

      if (fieldsDiv) {
        fieldsDiv.appendChild(labelField);
        fieldsDiv.appendChild(selectField);
        levelsDiv.appendChild(labelLevel);
        levelsDiv.appendChild(selectLevel);
      } else {
        skillsDiv.appendChild(labelField); 
        skillsDiv.appendChild(selectField);
        skillsDiv.appendChild(labelLevel); 
        skillsDiv.appendChild(selectLevel);
      }
  
      counter++;
    });
  }
};

export { addSkill };
