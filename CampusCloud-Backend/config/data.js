const permissions = [
    {
      facility: "Department Facility",
      examples: ["Classrooms of CSE"],
      authorities: ["HOD of department"],
      emails: ["csehod@sggs.ac.in"]
    },
    {
      facility: "Ground Facilities",
      examples: ["Sports ground"],
      authorities: ["Sport faculty coordinator", "Organising faculty coordinator", "Dean of affairs"],
      emails: ["csehod@sggs.ac.in"]
    },
    {
      facility: "College Facilities",
      examples: ["Auditorium", "Conference hall"],
      authorities: ["Dean of affairs"],
      emails: ["csehod@sggs.ac.in"]
    },
    {
      facility: "Club Events",
      examples: ["Technical fests", "Cultural events"],
      authorities: ["General secretary", "Faculty coordinator of club"],
      emails: ["csehod@sggs.ac.in"]
    },
    {
      facility: "Leave Certificate",
      examples: ["Medical leave", "Personal leave"],
      authorities: ["Class coordinator", "HOD of department"],
      emails: ["csehod@sggs.ac.in"]
    }
  ];

  const applications = {
    LeaveApplication : ["67ba1c5c70096377beb26422"/*class coordinator*/, "67b776e7f4945bf2bc1bd8f5"/*HOD */],
    EventOrganisation : ["67ba0e6d70096377beb2641e"/*Dean of affairs */, "67ba21b270096377beb26425"/*Director */],
    GirlsHostelPermission : [ "67b776e7f4945bf2bc1bd8f5"/*hod */, "67ba10cf70096377beb26420"/*Girls hostel warden */],
    BoysHostelPermission : ["67b776e7f4945bf2bc1bd8f5"/*HOD */],
    GroundPermission : ["67ba0e6d70096377beb2641e"/*Dean of affairs */, "67ba21b270096377beb26425"/*Director */],
  }